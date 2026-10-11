function model = tensor_cp_als(tensor,rank,iterations,ridge)
%TENSOR_CP_ALS CANDECOMP/PARAFAC ALS for neuron x time x trial tensor.
% Williams et al. (2018), doi:10.1016/j.neuron.2018.05.015.
% Elementary CP algorithm; no TCA fitting constraints or rank selection.
if nargin<3 || isempty(iterations), iterations=40; end
if nargin<4 || isempty(ridge), ridge=1e-7; end
x=double(tensor); dims=size(x);
assert(ndims(x)==3 && all(isfinite(x(:))) && ...
    rank>=1 && rank==floor(rank) && iterations>=1 && ridge>0);
a=rand(dims(1),rank); b=rand(dims(2),rank); c=rand(dims(3),rank);
for iter=1:iterations
    kr=zeros(dims(2)*dims(3),rank);
    for z=1:rank, kr(:,z)=reshape(b(:,z)*c(:,z)',[],1); end
    a=(reshape(x,dims(1),[])*kr)/(kr'*kr+ridge*eye(rank));
    kr=zeros(dims(1)*dims(3),rank);
    for z=1:rank, kr(:,z)=reshape(a(:,z)*c(:,z)',[],1); end
    b=(reshape(permute(x,[2 1 3]),dims(2),[])*kr)/(kr'*kr+ridge*eye(rank));
    kr=zeros(dims(1)*dims(2),rank);
    for z=1:rank, kr(:,z)=reshape(a(:,z)*b(:,z)',[],1); end
    c=(reshape(permute(x,[3 1 2]),dims(3),[])*kr)/(kr'*kr+ridge*eye(rank));
end
reconstruction=zeros(dims);
for z=1:rank
    reconstruction=reconstruction+reshape(a(:,z),[],1,1) ...
        .*reshape(b(:,z),1,[],1).*reshape(c(:,z),1,1,[]);
end
model.neuron_factors=a;
model.temporal_factors=b;
model.trial_factors=c;
model.relative_error=norm(x(:)-reconstruction(:))/max(norm(x(:)),eps);
end
