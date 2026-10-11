%% smoke_ephys_methods: synthetic spike-quality and field-potential checks
% MATLAB R2019a+ with Signal Processing Toolbox. Not executed by author.
here=fileparts(mfilename('fullpath'));
addpath(fullfile(here,'..','path'));
rng(17)
rv=spike_refractory_violations([.1 .101 .4 .7],.002);
assert(rv.count==1 && rv.intervals==3 && abs(rv.fraction-1/3)<1e-12)
presence=spike_presence_ratio([.1 1.2 3.4],0,4,1);
assert(abs(presence.ratio-.75)<1e-12)
match=spike_sorting_agreement([.1 .2 .5],[.1001 .55 .6],.0002);
assert(match.true_positives==1 && match.false_positives==2 ...
    && match.false_negatives==2)
fs=500; t=(0:fs*8-1)'/fs;
lfp=sin(2*pi*8*t)+.01*randn(size(t));
[f,c]=multitaper_coherence(lfp,lfp,fs,1,3,5);
assert(numel(f)==numel(c) && max(abs(c-1))<1e-8)
[wc,wf,wt]=wavelet_coherence(lfp,lfp,fs,[6 8 10],6,.25);
assert(isequal(size(wc),[3 numel(lfp)]) && numel(wf)==3);
assert(numel(wt)==numel(lfp))
finite_wc=wc(isfinite(wc)); assert(~isempty(finite_wc));
assert(max(abs(finite_wc-1))<1e-8)
recording=[lfp';2*lfp';3*lfp'];
[r,common]=common_median_reference(recording);
assert(size(r,1)==3 && max(abs(median(r,1)))<1e-10);
assert(numel(common)==numel(lfp))
[bip,depth]=bipolar_reference_lfp(recording,[0;40;80]*1e-6);
assert(isequal(size(bip),[2 numel(lfp)]) && numel(depth)==2)
spikes=(.2:.15:7.5)';
[fc,coh]=spike_field_coherence(lfp,spikes,fs,1);
assert(numel(fc)==numel(coh))
g=[1 .2; .4 1; .3 -.4]; sources=[lfp';cos(2*pi*8*t)'];
potentials=field_potential_forward(g,sources);
inverse=field_potential_inverse_tikhonov(g,potentials,.001);
assert(norm(inverse.residual,'fro')/norm(potentials,'fro')<.01)
broadband=.01*randn(2,1200);
broadband(:,[100 300 700])=broadband(:,[100 300 700])-2;
[waveforms,kept]=spike_waveform_extraction(broadband,[100 300 700 1199],10,15);
assert(isequal(size(waveforms),[3 2 26]) && numel(kept)==3)
[avg,sem]=spike_waveform_average(waveforms);
assert(isequal(size(avg),[2 26]) && all(sem(:)>=0))
snr=spike_waveform_snr(avg,broadband(:,1:90));
assert(isfinite(snr.snr) && snr.snr>5)
disp('electrophysiology methods synthetic checks completed')
