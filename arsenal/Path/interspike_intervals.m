function intervals_s = interspike_intervals(spike_times)
%INTERSPIKE_INTERVALS Successive sorted event separations (seconds).
% Duplicate times yield 0; investigate recording/sample precision.
t=double(spike_times(:));
assert(all(isfinite(t)),'Spike times must be finite');
intervals_s=diff(sort(t));
end
