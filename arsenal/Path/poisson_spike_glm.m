function model = poisson_spike_glm(design,counts,bin_seconds,ridge,max_iterations)
%POISSON_SPIKE_GLM Binned log-link point-process approximation by IRLS.
% Truccolo et al. (2005). Columns are chosen covariates/spike history.
% Does not correct for latent shared drive, refractory effects or overdispersion.
if nargin<4 || isempty(ridge), ridge=1e-4; end
if nargin<5 || isempty(max_iterations), max_iterations=60; end
x=double(design); y=double(counts(:)); n=size(x,1);
assert(n==numel(y) && n>=4 && all(isfinite(x(:))) && ...
    all(isfinite(y)) && all(y>=0) && bin_seconds>0 && ridge>=0);
d=[ones(n,1) x]; p=size(d,2);
b=zeros(p,1);
b(1)=log(max(mean(y),1e-6)/bin_seconds);
penalty=diag([0;ones(p-1,1)])*ridge;
for iter=1:max_iterations
    eta=min(20,max(-20,d*b+log(bin_seconds)));
    mu=exp(eta);
    grad=d'*(mu-y)+penalty*b;
    hess=bsxfun(@times,d,mu)'*d+penalty+1e-8*eye(p);
    step=hess\grad;
    candidate=b-step;
    if norm(step)<1e-7*(1+norm(b)), b=candidate; break; end
    b=candidate;
end
model.intercept=b(1); model.coefficients=b(2:end);
model.expected_count=exp(min(20,max(-20,d*b+log(bin_seconds))));
model.iterations=iter;
model.note='Unvalidated IRLS draft; inspect fit, regularization and residuals';
end
