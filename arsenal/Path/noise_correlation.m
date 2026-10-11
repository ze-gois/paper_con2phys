function [correlation,residual] = noise_correlation(trial_counts,condition)
%NOISE_CORRELATION Trial residual correlations, subtracting each condition mean.
% Cohen & Kohn (2011). Trial x units counts and trial condition labels.
x=double(trial_counts);
assert(size(x,1)==numel(condition) && all(isfinite(x(:))));
condition=condition(:); [~,~,groups]=unique(condition);
residual=x;
for k=1:max(groups)
    selected=groups==k;
    residual(selected,:)=bsxfun(@minus,x(selected,:),mean(x(selected,:),1));
end
correlation=corrcoef(residual);
end
