function events = ripple_candidate_events(signal,srate,band_hz,onset_z,peak_z)
%RIPPLE_CANDIDATE_EVENTS Robust-envelope high-frequency candidate screen.
% Liu et al. (2022): detections require review before claiming sharp-wave ripples.
% Defaults 120..200 Hz, suitable only if Nyquist > 200 Hz.
if nargin<3 || isempty(band_hz), band_hz=[120 200]; end
if nargin<4 || isempty(onset_z), onset_z=2; end
if nargin<5 || isempty(peak_z), peak_z=5; end
x=double(signal(:)); assert(all(isfinite(x)),'Finite input required');
y=bandpass_lfp(x,srate,band_hz);
a=abs(hilbert(y)); baseline=median(a);
sigma=1.4826*median(abs(a-baseline));
assert(sigma>0,'Envelope has no robust variance');
z=(a-baseline)/sigma;
active=z>=onset_z;
starts=find(diff([false;active])==1);
stops=find(diff([active;false])==-1);
rows=zeros(0,4);
for k=1:numel(starts)
    first=starts(k); last=stops(k);
    length_s=(last-first+1)/srate;
    if first==1 || last==numel(x) || length_s<.025 || length_s>.150
        continue
    end
    peak=max(z(first:last));
    if peak>=peak_z
        rows(end+1,:)=[(first-1)/srate,last/srate,length_s,peak]; %#ok<AGROW>
    end
end
events=array2table(rows,'VariableNames', ...
    {'start_s','stop_s','duration_s','peak_robust_z'});
end
