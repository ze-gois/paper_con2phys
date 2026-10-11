function model = assembly_pca(spike_counts,n_components)
%ASSEMBLY_PCA Z-scored PCA templates for population coactivation patterns.
% Peyrache et al. (2010); Lopes-dos-Santos et al. (2013).
% Does not implement ICA or formal assembly significance testing.
x=double(spike_counts);
assert(ismatrix(x) && size(x,1)>=3 && all(isfinite(x(:))) && all(x(:)>=0));
mu=mean(x,1); sigma=std(x,0,1);
assert(all(sigma>0),'Remove silent units before assembly PCA');
z=bsxfun(@rdivide,bsxfun(@minus,x,mu),sigma);
if nargin<2 || isempty(n_components), n_components=min(size(z)); end
[u,s,v]=svd(z,'econ');
lambda=diag(s).^2/(size(z,1)-1);
k=min(n_components,size(v,2));
model.templates=v(:,1:k);
model.scores=u(:,1:k)*s(1:k,1:k);
model.eigenvalues=lambda;
model.mean=mu; model.std=sigma;
model.mp_upper=(1+sqrt(size(z,2)/size(z,1)))^2;
model.note='MP bound is an iid null approximation, not a surrogate test';
end
