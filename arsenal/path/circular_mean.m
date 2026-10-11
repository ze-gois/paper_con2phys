function [mean_angle,resultant_length] = circular_mean(angles,weights)
%CIRCULAR_MEAN Weighted circular mean in radians, Berens (2009) CircStat.
% DOI 10.18637/jss.v031.i10. Finite angles and nonnegative weights only.
% Mean undefined when resultant is numerically indistinguishable from 0.
if nargin<2 || isempty(weights), weights=ones(size(angles)); end
a=double(angles(:)); w=double(weights(:));
assert(numel(a)==numel(w) && ~isempty(a));
assert(all(isfinite(a)) && all(isfinite(w)) && all(w>=0) && sum(w)>0);
z=sum(w.*exp(1i*a))/sum(w);
resultant_length=abs(z);
mean_angle=angle(z);
if resultant_length<1e-12, mean_angle=NaN; end
end
