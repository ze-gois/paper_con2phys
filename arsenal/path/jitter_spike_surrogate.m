function surrogate = jitter_spike_surrogate(spike_times,window_s,origin_s)
%JITTER_SPIKE_SURROGATE Uniform jitter inside fixed non-overlapping windows.
% Amarasingham et al. (2012): simplified conditional-jitter null.
% Preserves total spikes per window; use caller-controlled random seed.
if nargin<3 || isempty(origin_s), origin_s=0; end
t=double(spike_times(:));
assert(all(isfinite(t)) && window_s>0 && isfinite(origin_s));
start=origin_s+floor((t-origin_s)/window_s)*window_s;
surrogate=sort(start+rand(size(t))*window_s);
end
