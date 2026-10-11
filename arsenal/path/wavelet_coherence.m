function [coherence,frequency,time] = wavelet_coherence(a,b,srate,frequencies,cycles,smoothing_seconds)
%WAVELET_COHERENCE Exploratory time-smoothed Morlet coherence.
% No cross-scale smoothing; exclude edge samples before inference.
if nargin<5 || isempty(cycles), cycles=6; end
if nargin<6 || isempty(smoothing_seconds), smoothing_seconds=.5; end
x=double(a(:)); y=double(b(:)); frequency=double(frequencies(:));
assert(numel(x)==numel(y) && all(isfinite(x)) && all(isfinite(y)));
assert(srate>0 && all(frequency>0 & frequency<srate/2));
n=numel(x); width=max(3,round(smoothing_seconds*srate));
assert(n>width && n*numel(frequency)<=5e6);
time=(0:n-1)'/srate;
coherence=nan(numel(frequency),n);
for k=1:numel(frequency)
    wx=morlet_wavelet(x,srate,frequency(k),cycles);
    wy=morlet_wavelet(y,srate,frequency(k),cycles);
    cross=movmean(wx.*conj(wy),width);
    px=movmean(abs(wx).^2,width);
    py=movmean(abs(wy).^2,width);
    value=abs(cross).^2./max(px.*py,realmin);
    coherence(k,:)=min(1,real(value))';
    edge=min(ceil(n/2),ceil(3.5*cycles*srate/(2*pi*frequency(k))));
    coherence(k,1:edge)=NaN;
    coherence(k,n-edge+1:n)=NaN;
end
end
