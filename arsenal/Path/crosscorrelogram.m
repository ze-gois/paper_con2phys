function [lags_s,counts] = crosscorrelogram(spikes_a,spikes_b,start_s,stop_s,bin_s,max_lag_s)
%CROSSCORRELOGRAM Lagged binned coincidence counts, without trial correction.
% Conventions: xcorr(a,b), positive lag means a follows b.
[a,~,~]=spike_bin_counts(spikes_a,start_s,stop_s,bin_s);
[b,~,~]=spike_bin_counts(spikes_b,start_s,stop_s,bin_s);
lag_bins=round(max_lag_s/bin_s);
assert(lag_bins>=1 && lag_bins<numel(a),'Invalid lag limit');
counts=xcorr(double(a),double(b),lag_bins);
lags_s=(-lag_bins:lag_bins)'*bin_s;
end
