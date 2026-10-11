function rate_hz = firing_rate(spike_times,start_s,stop_s)
%FIRING_RATE Mean firing rate from spike timestamps in seconds.
% Uses a half-open exposure interval; excludes events at stop_s.
assert(isfinite(start_s) && isfinite(stop_s) && stop_s>start_s);
x=double(spike_times(:));
assert(all(isfinite(x)),'Spike times must be finite');
rate_hz=sum(x>=start_s & x<stop_s)/(stop_s-start_s);
end
