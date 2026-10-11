function model = jpca_dynamics(trajectory,dt)
%JPCA_DYNAMICS Skew-symmetric least-squares rotational dynamics.
% Churchland et al. (2012), doi:10.1038/nature11129.
% Pre-smoothed, aligned latent trajectory (time x dimension), not full jPCA.
x=double(trajectory); [n,k]=size(x);
assert(n>=5 && k>=2 && k<=10 && all(isfinite(x(:))) && dt>0);
xdot=(x(3:end,:)-x(1:end-2,:))/(2*dt);
mid=x(2:end-1,:);
pairs=nchoosek(1:k,2); m=size(pairs,1);
design=zeros(numel(xdot),m);
for j=1:m
    g=zeros(k,k);
    g(pairs(j,1),pairs(j,2))=1;
    g(pairs(j,2),pairs(j,1))=-1;
    tmp=mid*g; design(:,j)=tmp(:);
end
coeff=design\xdot(:);
M=zeros(k);
for j=1:m
    i=pairs(j,1); l=pairs(j,2);
    M(i,l)=M(i,l)+coeff(j);
    M(l,i)=M(l,i)-coeff(j);
end
residual=xdot-mid*M;
model.generator=M;
model.eigenvalues=eig(M);
model.residual_fraction=sum(residual(:).^2)/max(sum(xdot(:).^2),eps);
model.predicted_derivative=mid*M;
end
