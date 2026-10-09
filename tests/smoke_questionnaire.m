%% Run in a fresh MATLAB session with Signal Processing Toolbox.
% Synthetic smoke checks only; NOT evidence about the real recordings.
root=fileparts(fileparts(mfilename('fullpath'))); addpath(root);
rng(7); fs=500; duration=180; time=(0:duration*fs-1)/fs;
data=struct('srate',fs);
for a=1:3
    data.(sprintf('lfp_%d',a))=repmat(a*sin(2*pi*10*time),3,1)+.05*randn(3,numel(time));
end
data.waveform_cluster=int32((101:109)'); data.waveform_area=repelem((1:3)',3);
data.spike_cluster=int32([]); data.spike_timestamp=[];
for u=1:9
    % Distinct known rates; boundary events at T must be excluded.
    n=180*u; spike=sort(duration*rand(1,n));
    data.spike_timestamp=[data.spike_timestamp spike];
    data.spike_cluster=[data.spike_cluster repmat(int32(100+u),1,n)];
end
data.spike_timestamp(end+1)=duration; data.spike_cluster(end+1)=int32(101);
data.waveform=zeros(9,128);
for u=1:9
    w=zeros(1,128); w(40)=-1;
    if mod(u,3)==1, w(46)=.5; else, w(58)=.5; end
    data.waveform(u,:)=w;
end
start=(1:6:175)';
data.trial=[(1:30)' start start+1 start+2 start+4 mod((1:30)',2) zeros(30,1) mod((1:30)',3)+1];
data.trial_columns=struct('trial_start',2,'stim_start',3,'outcome',4,'trial_end',5,'A',6,'C',8);
qcfg=struct('bootstrap',20,'matched_units',3);
q01_firing_rate
assert(max(abs(q01.unit.rate_hz-(1:9)'))<1e-12);
assert(q01.excluded_spikes==1);
q02_broadband_power
assert(all(abs(q02.summary.mean-[.5;2;4.5])<.1));
q03_ripple_density
q04_spike_interactions
q05_undirected_connectivity
q06_directed_connectivity
q07_fast_spiking
assert(all(abs(q07.summary.mean-1/3)<1e-12));
q08_phase_locking
assert(all(q08.unit.ppc(isfinite(q08.unit.ppc))<=1+1e-12));
q09_excitation_inhibition
assert(all(q09.summary.mean==2));
q10_intrinsic_timescale
q11_variable_a_information
q12_variable_c_decoding
q13_dimensionality
assert(all(q13.summary.mean>=1 & q13.summary.mean<=3+1e-10));
q14_modularity
q15_signal_complexity
assert(all(q15.summary.mean>=0 & q15.summary.mean<=1));
for number=1:15
    result=eval(sprintf('q%02d',number));
    assert(height(result.summary)==3);
end
fprintf('All 15 synthetic smoke checks passed.\n');
