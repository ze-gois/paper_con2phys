function model = reduced_rank_regression(source,target,rank,ridge)
%REDUCED_RANK_REGRESSION Low-rank multivariate ridge prediction.
% Semedo et al. (2019), doi:10.1016/j.neuron.2019.01.026.
% Observations x units; training only. Rank and ridge require CV selection.
if nargin<4 || isempty(ridge), ridge=1e-6; end
x=double(source); y=double(target);
[n,p]=size(x); [ny,q]=size(y);
assert(n==ny && n>=3 && all(isfinite(x(:))) && all(isfinite(y(:))));
assert(isscalar(rank) && rank==floor(rank) && rank>=1 && rank<=min(p,q));
assert(ridge>=0 && isfinite(ridge));
mx=mean(x,1); my=mean(y,1);
xc=bsxfun(@minus,x,mx); yc=bsxfun(@minus,y,my);
b=(xc'*xc+ridge*eye(p))\(xc'*yc);
prediction=xc*b;
[~,~,v]=svd(prediction,'econ');
projector=v(:,1:rank)*v(:,1:rank)';
coef=b*projector;
[span,~,~]=svd(coef,'econ');
model.coefficients=coef;
model.source_mean=mx;
model.target_mean=my;
model.prediction=bsxfun(@plus,xc*coef,my);
model.source_axes=span(:,1:rank);
model.target_axes=v(:,1:rank);
model.rank=rank;
model.ridge=ridge;
end
