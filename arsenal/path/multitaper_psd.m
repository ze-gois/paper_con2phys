function [frequency, power] = multitaper_psd(signal, srate, time_bandwidth, tapers)
%MULTITAPER_PSD Thomson multitaper PSD from orthogonal DPSS tapers.
% Mitra & Pesaran (1999); Bokil et al. (2010). No adaptive weighting here.
if nargin<3 || isempty(time_bandwidth), time_bandwidth=3; end
if nargin<4 || isempty(tapers), tapers=floor(2*time_bandwidth-1); end
validateattributes(signal,{'numeric'},{'vector','real','finite','nonempty'});
validateattributes(srate,{'numeric'},{'scalar','positive','finite'});
assert(time_bandwidth>1 && tapers>=1 && tapers<2*time_bandwidth, ...
    'Specify 1 <= tapers < 2*time_bandwidth');
x=double(signal(:)); n=numel(x);
assert(n>=16,'Use at least 16 samples');
w=dpss(n,time_bandwidth,tapers);
nfft=max(256,2^nextpow2(n));
power=zeros(floor(nfft/2)+1,1);
for k=1:tapers
    [p,frequency]=periodogram(x,w(:,k),nfft,srate,'psd');
    power=power+p;
end
power=power/tapers;
end
