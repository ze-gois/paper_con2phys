function counts = spike_counts_edges(spike_times,edges)
%SPIKE_COUNTS_EDGES Event counts for explicit, possibly irregular [left,right) bins.
% Empty spike trains are valid. Nonfinite timestamps are excluded.
validateattributes(spike_times,{'numeric'},{'real'});
assert(isempty(spike_times) || isvector(spike_times),'Expected one spike train.');
validateattributes(edges,{'numeric'},{'vector','real','finite','increasing'});
assert(numel(edges)>=2,'At least two edges are required.');
t=double(spike_times(:)); edges=double(edges(:).');
t=t(isfinite(t) & t>=edges(1) & t<edges(end));
counts=histcounts(t,edges).';
end
