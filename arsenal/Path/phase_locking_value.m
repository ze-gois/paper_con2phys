function value = phase_locking_value(phase_a,phase_b)
%PHASE_LOCKING_VALUE Resultant magnitude of phase differences, [0,1].
% Lachaux et al. (1999). Does not remove common-reference effects.
a=double(phase_a(:)); b=double(phase_b(:));
assert(numel(a)==numel(b),'Phase vectors must match');
valid=isfinite(a)&isfinite(b);
assert(nnz(valid)>=2,'At least two matched samples required');
value=abs(mean(exp(1i*(a(valid)-b(valid)))));
end
