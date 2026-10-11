%% Synthetic regression test for path/lfp_envelope_moments.m (MATLAB R2019a+)
% Requires Signal Processing Toolbox. No real CON2PHYS data are needed.
root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root,'path'));
fs = 500;
duration = 26;
t = (0:duration*fs-1)/fs;
x = (1+0.4*sin(2*pi*0.13*t)).*sin(2*pi*8*t) + ...
    0.15*sin(2*pi*22*t) + 0.10*sin(2*pi*45*t);
lfp = [x;zeros(1,numel(x));nan(1,numel(x))];

m = lfp_envelope_moments(lfp,fs,'TimeOriginSeconds',32, ...
    'ChannelIds',[11 12 13],'ChunkWindows',13);
n = floor((numel(t)-10*fs)/(0.1*fs))+1;
assert(isequal(size(m.mean),[n 3 3]));
assert(isequal(size(m.variance),[n 3 3]));
assert(isequal(size(m.skewness),[n 3 3]));
assert(isequal(size(m.excess_kurtosis),[n 3 3]));
assert(isequal(m.channel_valid,[true;true;false]));
assert(isequal(m.channel_ids,[11 12 13]));
assert(all(strcmp(m.band_names,{'theta','beta','gamma'})));
assert(isequal(m.band_hz,[4 12;13 30;30 80]));
assert(abs(m.window_start_seconds(1)-32)<1e-12);
assert(abs(m.window_end_seconds(1)-42)<1e-12);
assert(abs(m.time_seconds(1)-(32+(5000-1)/(2*fs)))<1e-12);
assert(abs(diff(m.time_seconds(1:2))-0.1)<1e-12);
assert(abs(m.window_end_seconds(end)-58)<1e-12);
assert(m.edge_affected(1) && m.edge_affected(end));
assert(any(~m.edge_affected));

% An identically zero channel has zero mean/variance, undefined shape.
assert(all(m.mean(:,2,:)==0,'all'));
assert(all(m.variance(:,2,:)==0,'all'));
assert(all(isnan(m.skewness(:,2,:)),'all'));
assert(all(isnan(m.excess_kurtosis(:,2,:)),'all'));
% A nonfinite channel is never silently interpolated or substituted.
assert(all(isnan(m.mean(:,3,:)),'all'));
assert(isequal(m.provenance.invalid_channel_ids,13));

j = find(~m.edge_affected,1,'first');
assert(m.mean(j,1,1)>m.mean(j,1,2));
assert(m.mean(j,1,2)>m.mean(j,1,3));
assert(m.variance(j,1,1)>0);

% Cross-check against direct window evaluation, including standardized
% moments and the expected zero-phase/SOS/Hilbert signal definition.
[z,p,k] = butter(4,[4 12]/(fs/2),'bandpass');
[sos,g] = zp2sos(z,p,k);
env = abs(hilbert(filtfilt(sos,g,x(:))));
segment = env(m.window_start_sample(j):m.window_end_sample(j));
reference_mu = mean(segment);
centered = segment-reference_mu;
reference_var = mean(centered.^2);
reference_skew = mean(centered.^3)/reference_var^(3/2);
reference_kurt = mean(centered.^4)/reference_var^2-3;
assert(abs(m.mean(j,1,1)-reference_mu)<1e-10);
assert(abs(m.variance(j,1,1)-reference_var)<1e-10);
assert(abs(m.skewness(j,1,1)-reference_skew)<1e-7);
assert(abs(m.excess_kurtosis(j,1,1)-reference_kurt)<1e-6);

% Moment blocking must not change numerical results.
m2 = lfp_envelope_moments(x,fs,'TimeOriginSeconds',32, ...
    'ChunkWindows',64,'OutputClass','single');
assert(isequal(size(m2.mean),[n 1 3]));
assert(strcmp(class(m2.mean),'single'));
assert(max(abs(double(m2.mean(:,1,1))-m.mean(:,1,1)))<1e-5);
assert(max(abs(double(m2.variance(:,1,1))-m.variance(:,1,1)))<1e-5);
fprintf('LFP envelope sliding-moments synthetic checks passed.\n');
