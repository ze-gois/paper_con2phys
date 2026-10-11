function expression = assembly_expression(zscores,templates)
%ASSEMBLY_EXPRESSION Pairwise assembly coactivation excluding diagonal terms.
% Project onto PCA/ICA templates; input zscores MUST match fitted unit order.
% Peyrache et al. (2010); Lopes-dos-Santos et al. (2013).
z=double(zscores); v=double(templates);
assert(size(z,2)==size(v,1) && all(isfinite(z(:))) && all(isfinite(v(:))));
expression=zeros(size(z,1),size(v,2));
for k=1:size(v,2)
    weights=v(:,k);
    expression(:,k)=(z*weights).^2-(z.^2)*(weights.^2);
end
end
