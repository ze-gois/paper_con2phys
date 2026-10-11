function out = spike_presence_ratio(times,start_seconds,stop_seconds,bin_seconds)
%SPIKE_PRESENCE_RATIO Fraction of time bins containing any sorted spike.
% Analog to SpikeInterface presence ratio. Empty bins may reflect low rate.
times=double(times(:));
assert(all(isfinite(times)) && stop_seconds>start_seconds && ...
    all(isfinite([start_seconds stop_seconds bin_seconds])) && bin_seconds>0);
n=floor((stop_seconds-start_seconds)/bin_seconds);
assert(n>=1,'At least one complete time bin required');
edges=start_seconds+(0:n)*bin_seconds;
counts=histcounts(times(times>=edges(1) & times<edges(end)),edges);
out.ratio=mean(counts>0);
out.counts=counts(:);
out.edges_seconds=edges(:);
out.unused_tail_seconds=stop_seconds-edges(end);
end
