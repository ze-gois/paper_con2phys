function width_ms = waveform_trough_to_peak(waveform,srate)
%WAVEFORM_TROUGH_TO_PEAK Trough to subsequent positive peak time in ms.
% Used for extracellular waveform classification, not definitive cell identity.
% Input is one averaged waveform; use waveform sampling rate (often 30000 Hz).
validateattributes(waveform,{'numeric'},{'vector','real','finite','nonempty'});
assert(srate>0,'Sample rate must be positive');
w=double(waveform(:));
[~,trough]=min(w);
if trough==numel(w), width_ms=NaN; return; end
[~,peak_rel]=max(w(trough+1:end));
width_ms=1000*peak_rel/srate;
end
