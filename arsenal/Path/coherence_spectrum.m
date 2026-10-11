function [frequency, coherence] = coherence_spectrum(a,b,srate,window_seconds)
%COHERENCE_SPECTRUM Welch magnitude-squared coherence, 0..1.
% Bastos & Schoffelen (2016): coherence is not directed connectivity.
if nargin<4 || isempty(window_seconds), window_seconds=4; end
x=double(a(:)); y=double(b(:));
assert(numel(x)==numel(y) && all(isfinite(x)) && all(isfinite(y)), ...
    'Signals must match and be finite');
n=round(window_seconds*srate);
assert(n>=8 && numel(x)>=2*n,'Need at least two windows');
w=hann(n,'periodic'); noverlap=floor(n/2);
[coherence,frequency]=mscohere(x,y,w,noverlap,max(256,2^nextpow2(n)),srate);
end
