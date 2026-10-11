function model = aperiodic_slope(frequency,power,fit_band,exclude_bands)
%APERIODIC_SLOPE Log-log linear 1/f fit; NOT full FOOOF/specparam.
% Donoghue et al. (2020). Exclude peaks explicitly before fitting.
if nargin<4, exclude_bands=zeros(0,2); end
frequency=double(frequency(:)); power=double(power(:));
assert(numel(frequency)==numel(power) && numel(fit_band)==2, ...
    'Frequency, PSD and fit_band dimensions mismatch');
keep=isfinite(frequency)&isfinite(power)&frequency>0&power>0 ...
    &frequency>=fit_band(1)&frequency<=fit_band(2);
for k=1:size(exclude_bands,1)
    keep=keep & ~(frequency>=exclude_bands(k,1) & ...
                    frequency<=exclude_bands(k,2));
end
assert(nnz(keep)>=3,'Insufficient valid bins for log-log fitting');
p=polyfit(log10(frequency(keep)),log10(power(keep)),1);
model.slope=p(1); model.exponent=-p(1); model.intercept=p(2);
model.background=10.^polyval(p,log10(max(frequency,realmin)));
model.frequency_hz=frequency; model.fit_mask=keep;
model.note='Linear log-log approximation, not specparam peak decomposition';
end
