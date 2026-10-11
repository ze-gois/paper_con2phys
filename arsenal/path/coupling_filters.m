function result = coupling_filters(spike_counts,lags,bin_seconds,ridge)
%COUPLING_FILTERS Fit coupled multineuron Poisson GLMs to lagged spikes.
% Pillow et al. (2008), Nature, DOI 10.1038/nature07140.
% Uses spike_history_design and poisson_spike_glm (IRLS draft).
% Input: time bins x units, nonnegative binned spike counts.
% Output filters: target unit x source unit x lag (lags in time bins).
% Coefficients denote conditional log-rate effects, NOT synaptic causality.
if nargin<4 || isempty(ridge), ridge=1; end
counts=double(spike_counts);
assert(ismatrix(counts) && size(counts,2)>=2 && ...
    all(isfinite(counts(:))) && all(counts(:)>=0));
assert(bin_seconds>0 && isfinite(bin_seconds) && ridge>0);
[design,valid_bins]=spike_history_design(counts,lags);
units=size(counts,2);
filters=nan(units,units,lags);
intercept=nan(units,1);
log_rate=nan(numel(valid_bins),units);
for target=1:units
    model=poisson_spike_glm(design,counts(valid_bins,target), ...
        bin_seconds,ridge);
    coefficients=reshape(model.coefficients,[lags units])';
    filters(target,:,:)=reshape(coefficients,[1 units lags]);
    intercept(target)=model.intercept;
    log_rate(:,target)=log(max(model.expected_count,realmin) ...
        /bin_seconds);
end
result.filters=filters;
result.intercept=intercept;
result.log_rate=log_rate;
result.valid_bins=valid_bins;
result.lag_seconds=(1:lags)*bin_seconds;
result.ridge=ridge;
result.note=['Exploratory regularized coupled GLM; validate residuals, ' ...
    'overdispersion, dependence, unobserved drives and held-out likelihood'];
end
