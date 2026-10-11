function entropy_value = spectral_entropy(power)
%SPECTRAL_ENTROPY Shannon entropy of a nonnegative PSD, normalized 0..1.
% Requires comparable frequency bins; does not measure physiological complexity.
p=double(power(:));
assert(all(isfinite(p)) && all(p>=0) && numel(p)>=2, ...
    'PSD must have at least two finite nonnegative bins');
assert(sum(p)>0,'PSD has zero total power');
p=p/sum(p); p=p(p>0);
entropy_value=-sum(p.*log(p))/log(numel(power));
end
