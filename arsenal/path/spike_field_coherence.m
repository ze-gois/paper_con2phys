function [frequency,coherence] = spike_field_coherence(lfp,spike_times,srate,window_seconds)
%SPIKE_FIELD_COHERENCE Magnitude-squared coherence of binned spikes and LFP.
% Field-potential coding analysis; NOT pairwise phase consistency.
% spike_times in seconds, same zero time origin as LFP.
if nargin<4 || isempty(window_seconds), window_seconds=4; end
x=double(lfp(:)); t=double(spike_times(:)); n=numel(x);
assert(all(isfinite(x)) && all(isfinite(t)) && srate>0);
assert(all(t>=0) && all(t<n/srate),'Event outside recording');
segment=round(window_seconds*srate);
assert(segment>=16 && n>=2*segment,'Require at least two segments');
sample=floor(t*srate)+1;
counts=accumarray(sample,1,[n 1]);
w=hann(segment,'periodic');
[coherence,frequency]=mscohere(counts,x,w,floor(segment/2), ...
    2^nextpow2(segment),srate);
end
