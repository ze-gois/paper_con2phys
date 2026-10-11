function [bipolar,midpoint_depth] = bipolar_reference_lfp(potential,depth_m)
%BIPOLAR_REFERENCE_LFP Adjacent laminar voltage differences.
% Channels must be ordered by physical depth and share consistent units.
% Difference is not itself a CSD estimate.
x=double(potential); z=double(depth_m(:));
assert(ismatrix(x) && size(x,1)>=2 && numel(z)==size(x,1));
assert(all(isfinite(x(:))) && all(isfinite(z)) && all(diff(z)>0));
bipolar=diff(x,1,1);
midpoint_depth=(z(1:end-1)+z(2:end))/2;
end
