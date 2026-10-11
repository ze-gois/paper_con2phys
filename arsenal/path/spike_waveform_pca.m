function model = spike_waveform_pca(waveforms,n_components)
%SPIKE_WAVEFORM_PCA PCA features of aligned extracellular waveforms.
% Rows are waveforms, columns sampled voltages, all in comparable units.
% Used in sorting pipelines; PCA alone is not spike sorting.
x=double(waveforms);
assert(ismatrix(x) && size(x,1)>=2 && all(isfinite(x(:))));
if nargin<2 || isempty(n_components), n_components=3; end
mu=mean(x,1);
[u,s,v]=svd(bsxfun(@minus,x,mu),'econ');
k=min(n_components,size(v,2));
model.scores=u(:,1:k)*s(1:k,1:k);
model.loadings=v(:,1:k); model.mean=mu;
end
