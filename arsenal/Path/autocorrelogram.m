function [lags_s,counts] = autocorrelogram(spike_times,start_s,stop_s,bin_s,max_lag_s)
%AUTOCORRELOGRAM Binned spike-train autocorrelation (count coincidences).
% Bin width determines resolution; central zero-lag includes self-pairs.
[b,~,~]=spike_bin_counts(spike_times,start_s,stop_s,bin_s);
lag_bins=round(max_lag_s/bin_s);
assert(lag_bins>=1 && lag_bins<numel(b),'Invalid lag limit');
counts=xcorr(double(b),lag_bins);
lags_s=(-lag_bins:lag_bins)'*bin_s;
end
