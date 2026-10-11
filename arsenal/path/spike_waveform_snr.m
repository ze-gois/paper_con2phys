function metric = spike_waveform_snr(template,baseline_noise)
%SPIKE_WAVEFORM_SNR Template peak amplitude divided by robust noise.
% Channel x waveform and channel x baseline samples, respectively.
a=double(template); b=double(baseline_noise);
assert(size(a,1)==size(b,1) && size(a,2)>=2 && size(b,2)>=10);
assert(all(isfinite(a(:))) && all(isfinite(b(:))));
sigma=median(abs(bsxfun(@minus,b,median(b,2))),2)/.67448975;
assert(all(sigma>0));
values=max(abs(a),[],2)./sigma;
[metric.snr,metric.channel]=max(values);
metric.by_channel=values;
end
