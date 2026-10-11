function [counts,centers,edges] = spike_bin_counts(spike_times,start_s,stop_s,bin_s)
%SPIKE_BIN_COUNTS Count events in half-open [start,stop) bins.
% Truccolo et al. (2005): discrete count representation for point-process GLMs.
assert(isvector(spike_times) && all(isfinite(spike_times)));
assert(isfinite(start_s) && isfinite(stop_s) && stop_s>start_s && bin_s>0);
nbins=floor((stop_s-start_s)/bin_s);
assert(nbins>=1,'Insufficient recording duration');
edges=start_s+(0:nbins)*bin_s;
x=spike_times(:); x=x(x>=start_s & x<edges(end));
counts=histcounts(x,edges).';
centers=(edges(1:end-1).'+edges(2:end).')/2;
end
