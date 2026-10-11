function out = spike_refractory_violations(times,refractory_seconds)
%SPIKE_REFRACTORY_VIOLATIONS Adjacent short-ISI proportion; not contamination.
% Hill et al. (2011); quality metric candidate, timestamps in seconds.
if nargin<2 || isempty(refractory_seconds), refractory_seconds=.002; end
times=double(times(:));
assert(all(isfinite(times)) && refractory_seconds>0);
isi=diff(sort(times));
out.count=sum(isi<refractory_seconds);
out.intervals=numel(isi);
out.fraction=NaN;
if ~isempty(isi), out.fraction=out.count/out.intervals; end
out.threshold_seconds=refractory_seconds;
end
