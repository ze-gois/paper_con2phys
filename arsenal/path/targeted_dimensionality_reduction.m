function model = targeted_dimensionality_reduction(activity,labels)
%TARGETED_DIMENSIONALITY_REDUCTION dDR signal and noise plane.
% Heller & David (2022), doi:10.1371/journal.pone.0271136.
% Use training data only; never fit projection using held-out trials.
x=double(activity); labels=labels(:);
assert(size(x,1)==numel(labels) && size(x,2)>=2 && all(isfinite(x(:))));
c=condition_marginalization(x,labels);
assert(numel(c.conditions)==2 && all(c.counts>=2),'Two conditions, >=2 trials each');
delta=c.condition_means(2,:)-c.condition_means(1,:);
assert(norm(delta)>0,'No population mean difference');
signal=delta(:)/norm(delta);
[~,~,v]=svd(c.noise_residual,'econ');
noise=v(:,1)-signal*(signal'*v(:,1));
if norm(noise)<1e-10 && size(v,2)>=2
    noise=v(:,2)-signal*(signal'*v(:,2));
end
assert(norm(noise)>1e-10,'Noise direction unresolved');
basis=[signal noise/norm(noise)];
model.basis=basis;
model.center=mean(x,1);
model.scores=bsxfun(@minus,x,model.center)*basis;
model.conditions=c.conditions;
model.note='Two-condition dDR; test generalization with held-out trials';
end
