function [waves,kept] = spike_waveform_extraction(recording,indices,before,after)
%SPIKE_WAVEFORM_EXTRACTION Event-aligned AP snippets from multichannel data.
% Input recording=channels x samples, indices=MATLAB one-based sample indices.
% Output spikes x channels x waveform_samples. NOT for downsampled LFP.
assert(isnumeric(recording) && ismatrix(recording) && isreal(recording));
[nchannels,nsamples]=size(recording);
indices=double(indices(:));
assert(all(isfinite(indices)) && all(indices==floor(indices)) && all(indices>=1));
assert(before>=0 && after>=0 && before==floor(before) && after==floor(after));
kept=find(indices>before & indices+after<=nsamples);
width=before+after+1;
assert(numel(kept)*nchannels*width<=2e7,'Use smaller spike batches');
waves=zeros(numel(kept),nchannels,width,'single');
for k=1:numel(kept)
    fragment=recording(:,indices(kept(k))+(-before:after));
    waves(k,:,:)=reshape(single(fragment),[1 nchannels width]);
end
end
