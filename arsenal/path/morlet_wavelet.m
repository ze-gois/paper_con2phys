function [coefficient, time] = morlet_wavelet(signal,srate,frequency_hz,cycles)
%MORLET_WAVELET Complex Morlet convolution at one central frequency.
% Time resolution varies with cycles/frequency; output is complex-valued.
if nargin<4 || isempty(cycles), cycles=6; end
validateattributes(signal,{'numeric'},{'vector','real','finite','nonempty'});
assert(srate>0 && frequency_hz>0 && frequency_hz<srate/2 && cycles>=3, ...
    'Invalid sampling rate, frequency or cycles');
sigma=cycles/(2*pi*frequency_hz);
t=(-ceil(3.5*sigma*srate):ceil(3.5*sigma*srate))'/srate;
kernel=(exp(1i*2*pi*frequency_hz*t)-exp(-cycles^2/2)) ...
    .*exp(-t.^2/(2*sigma^2));
kernel=kernel/sqrt(sum(abs(kernel).^2));
coefficient=conv(double(signal(:)),kernel,'same');
time=(0:numel(signal)-1)'/srate;
end
