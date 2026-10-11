function shifted = circular_shift_surrogate(signal,shift_samples)
%CIRCULAR_SHIFT_SURROGATE Circular temporal shift, preserving sample distribution.
% For PAC/locking nulls choose shifts outside autocorrelation time, avoid edges.
assert(isvector(signal) && ~isempty(signal),'Input must be a vector');
assert(isscalar(shift_samples) && isfinite(shift_samples) && ...
    shift_samples==round(shift_samples),'Shift must be an integer');
shifted=circshift(signal,shift_samples);
end
