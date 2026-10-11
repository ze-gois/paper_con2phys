function [referenced,common] = common_median_reference(recording)
%COMMON_MEDIAN_REFERENCE Subtract median across channels at each sample.
% Inputs channels x samples; robust common-mode suppression.
% Shared neural activity can also be attenuated. Compare reference schemes.
assert(isnumeric(recording) && ismatrix(recording) && ...
    size(recording,1)>=2 && all(isfinite(recording(:))));
common=median(double(recording),1);
referenced=bsxfun(@minus,double(recording),common);
end
