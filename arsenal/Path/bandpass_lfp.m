function filtered = bandpass_lfp(signal, srate, band_hz, order)
%BANDPASS_LFP Zero-phase Butterworth filter for a finite LFP vector.
% Filtering is not artifact removal; filtfilt introduces edge transients.
if nargin<4 || isempty(order), order=4; end
validateattributes(signal,{'numeric'},{'real','vector','finite'});
validateattributes(srate,{'numeric'},{'scalar','positive','finite'});
assert(numel(band_hz)==2 && 0<band_hz(1) && ...
    band_hz(1)<band_hz(2) && band_hz(2)<srate/2, ...
    'Band must lie strictly inside (0, Nyquist)');
validateattributes(order,{'numeric'},{'scalar','integer','positive'});
was_row=isrow(signal);
x=double(signal(:));
assert(numel(x)>max(30,6*order),'Input is too short for zero-phase filtering');
[z,p,k]=butter(order,band_hz/(srate/2),'bandpass');
[sos,g]=zp2sos(z,p,k);
filtered=filtfilt(sos,g,x);
if was_row, filtered=filtered.'; end
end
