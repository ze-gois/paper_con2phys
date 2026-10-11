function [design,valid_bins] = spike_history_design(spike_counts,lags)
%SPIKE_HISTORY_DESIGN Causal spike-count regressors for coupled Poisson GLMs.
% Truccolo et al. (2005), Pillow et al. (2008).
% Input: time bins x recorded units (counts, not spike timestamps).
% Each column j,l corresponds to unit j at time t-l, l >= 1.
% No contemporaneous counts are used; this is not causal identification.
counts=double(spike_counts);
[n,units]=size(counts);
assert(ismatrix(counts) && n>=4 && units>=1 && ...
    all(isfinite(counts(:))) && all(counts(:)>=0));
assert(isscalar(lags) && lags==floor(lags) && lags>=1 && ...
    n-lags>=4);
valid_bins=(lags+1:n)';
rows=numel(valid_bins); columns=units*lags;
assert(rows*columns<=1e7,'Use fewer bins, units, or lags');
design=zeros(rows,columns);
for unit=1:units
    for lag=1:lags
        col=(unit-1)*lags+lag;
        design(:,col)=counts(valid_bins-lag,unit);
    end
end
end
