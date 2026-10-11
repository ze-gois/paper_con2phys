function result = field_potential_inverse_tikhonov(leadfield,potentials,lambda)
%FIELD_POTENTIAL_INVERSE_TIKHONOV Ridge-regularized inverse lead-field map.
% Pesaran et al. (2018): the inverse problem is nonunique/ill-posed.
% Needs physically specified leadfield, noise model, regularization and checks.
g=double(leadfield); y=double(potentials);
assert(ismatrix(g) && ismatrix(y) && size(g,1)==size(y,1));
assert(all(isfinite(g(:))) && all(isfinite(y(:))));
assert(isscalar(lambda) && isfinite(lambda) && lambda>0);
n=size(g,2);
x=(g'*g+lambda*eye(n))\(g'*y);
result.sources=x;
result.prediction=g*x;
result.residual=y-result.prediction;
result.lambda=lambda;
result.note='A regularized estimate, never a unique physiological source';
end
