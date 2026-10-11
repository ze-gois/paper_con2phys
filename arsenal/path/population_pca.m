function model = population_pca(activity,n_components)
%POPULATION_PCA PCA by SVD; rows observations, columns neuronal units.
% Cunningham & Yu (2014). Observation selection determines interpretation.
x=double(activity);
assert(ismatrix(x) && size(x,1)>=2 && all(isfinite(x(:))), ...
    'Need finite observations x units');
if nargin<2 || isempty(n_components), n_components=min(size(x)); end
center=mean(x,1);
[u,s,v]=svd(bsxfun(@minus,x,center),'econ');
k=min([n_components,size(v,2)]);
eigenvalues=diag(s).^2/(size(x,1)-1);
model.mean=center;
model.loadings=v(:,1:k);
model.scores=u(:,1:k)*s(1:k,1:k);
model.eigenvalues=eigenvalues;
model.explained=eigenvalues/sum(eigenvalues);
end
