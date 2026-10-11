function pli = phase_lag_index(phase_difference)
%PHASE_LAG_INDEX Absolute mean sign of phase lag (Stam et al. 2007).
% Zero-lag interactions are discarded; nonzero values are not proof of causality.
p=double(phase_difference(:)); p=p(isfinite(p));
if numel(p)<2, pli=NaN; return; end
pli=abs(mean(sign(sin(p))));
end
