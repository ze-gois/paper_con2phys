function result = condition_marginalization(activity,labels)
%CONDITION_MARGINALIZATION Separate condition means from trial residuals.
% Primitive used in demixing and dDR; not a complete dPCA algorithm.
x=double(activity); labels=labels(:);
assert(size(x,1)==numel(labels) && size(x,1)>=2 && all(isfinite(x(:))));
[conditions,~,g]=unique(labels);
k=numel(conditions); p=size(x,2);
means=zeros(k,p); counts=zeros(k,1);
for i=1:k
    block=x(g==i,:);
    means(i,:)=mean(block,1);
    counts(i)=size(block,1);
end
result.conditions=conditions;
result.group_index=g;
result.condition_means=means;
result.counts=counts;
result.noise_residual=bsxfun(@minus,x,means(g,:));
result.grand_mean=mean(x,1);
end
