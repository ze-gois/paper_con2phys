function result = linear_discriminability(a,b,ridge)
%LINEAR_DISCRIMINABILITY Pooled-covariance linear d-prime squared.
% Heller & David (2022), doi:10.1371/journal.pone.0271136.
if nargin<3 || isempty(ridge), ridge=1e-6; end
a=double(a); b=double(b);
assert(size(a,2)==size(b,2) && size(a,1)>=2 && size(b,1)>=2);
assert(all(isfinite(a(:))) && all(isfinite(b(:))) && ridge>=0);
na=size(a,1); nb=size(b,1); p=size(a,2);
delta=mean(b,1)-mean(a,1);
ca=bsxfun(@minus,a,mean(a,1));
cb=bsxfun(@minus,b,mean(b,1));
covariance=(ca'*ca+cb'*cb)/(na+nb-2)+ridge*eye(p);
weights=covariance\delta';
result.dprime_squared=delta*weights;
result.discrimination_axis=weights/max(norm(weights),eps);
result.mean_difference=delta;
result.ridge=ridge;
end
