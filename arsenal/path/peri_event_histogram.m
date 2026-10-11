function [centers_s,rate_hz,trial_counts] = peri_event_histogram(spike_times,event_times,edges_s)
%PERI_EVENT_HISTOGRAM Event-aligned firing rate and trial-by-bin counts.
% Nawrot et al. (1999). Events/trials may be dependent: interpret accordingly.
assert(isvector(spike_times) && isvector(event_times) && isvector(edges_s));
assert(all(diff(edges_s)>0) && all(isfinite(edges_s)));
assert(all(isfinite(spike_times)) && all(isfinite(event_times)));
assert(~isempty(event_times),'Provide at least one event');
trial_counts=zeros(numel(event_times),numel(edges_s)-1);
for k=1:numel(event_times)
    relative=double(spike_times(:))-event_times(k);
    trial_counts(k,:)=histcounts(relative,edges_s);
end
width=diff(edges_s(:));
rate_hz=mean(trial_counts,1)'./width;
centers_s=(edges_s(1:end-1)'+edges_s(2:end)')/2;
end
