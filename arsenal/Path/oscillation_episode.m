function [episodes,mask,p_episode] = oscillation_episode(above_threshold,srate,frequency_hz,minimum_cycles)
%OSCILLATION_EPISODE Find sustained oscillatory runs by minimum cycle count.
% BOSC operator: Whitten et al., NeuroImage (2011), DOI 10.1016/j.neuroimage.2010.08.064.
% Input: one logical or binary sample-per-time vector above a POWER threshold.
% Output: detected episodes in seconds, logical mask, proportion of total samples.
% Note: this is the duration decision step, not an entire BOSC estimator.
if nargin<4 || isempty(minimum_cycles), minimum_cycles=3; end
assert(isvector(above_threshold) && ~isempty(above_threshold));
assert(all(isfinite(double(above_threshold(:)))) && ...
    all(above_threshold(:)==0 | above_threshold(:)==1));
assert(isscalar(srate) && isfinite(srate) && srate>0);
assert(isscalar(frequency_hz) && isfinite(frequency_hz) && ...
    frequency_hz>0 && frequency_hz<srate/2);
assert(isscalar(minimum_cycles) && isfinite(minimum_cycles) && ...
    minimum_cycles>0);
input_row=isrow(above_threshold);
a=logical(above_threshold(:));
starts=find(diff([false; a; false])==1);
stops=find(diff([false; a; false])==-1)-1;
required=max(1,ceil(minimum_cycles*srate/frequency_hz));
keep=(stops-starts+1)>=required;
starts=starts(keep); stops=stops(keep);
mask=false(size(a));
for k=1:numel(starts), mask(starts(k):stops(k))=true; end
duration=(stops-starts+1)/srate;
episodes=table((starts-1)/srate,stops/srate,duration, ...
    duration*frequency_hz, ...
    'VariableNames',{'start_s','stop_s','duration_s','cycles'});
p_episode=mean(mask);
if input_row, mask=mask.'; end
end
