%% Run in a fresh MATLAB session; no real recordings required.
root=fileparts(fileparts(mfilename('fullpath')));
run(fullfile(root,'a00_startup.m'));
assert(strcmp(which('spike_counts_edges'),fullfile(root,'arsenal','path','spike_counts_edges.m')));
assert(strcmp(which('spike_bins'),fullfile(root,'path','spike_bins.m')));
edges=[0 0.1 0.4 1];
t=[-1 0 0.1 0.1 0.4 0.99 1 NaN Inf];
assert(isequal(spike_counts_edges(t,edges),[1;2;2]));
assert(isequal(spike_bins({t,[]},edges),[1 0;2 0;2 0]));
[counts,centers]=spike_bin_counts([],0,1,.25);
assert(isequal(counts,zeros(4,1)) && numel(centers)==4);
phase=[-.8 .2 .6 2.4]; z=exp(1i*phase); n=numel(z);
assert(abs(pairwise_phase_consistency(phase)-(abs(sum(z))^2-n)/(n*(n-1)))<1e-12);
assert(isnan(pairwise_phase_consistency([])));
disp('Path integration checks passed.');
