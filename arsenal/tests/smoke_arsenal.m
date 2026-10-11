%% smoke_arsenal: lightweight synthetic checks (MATLAB R2019a+).
% Not executed by the author; no real data, figures, downloads or files.
here=fileparts(mfilename('fullpath'));
addpath(fullfile(here,'..','path'))
rng(7)
fs=500; t=(0:fs*12-1)'/fs;
x=sin(2*pi*8*t)+.1*sin(2*pi*80*t)+.03*randn(size(t));
[f,p]=welch_psd(x,fs,2,.5);
[~,idx]=max(p);
assert(abs(f(idx)-8)<1)
[fm,pm]=multitaper_psd(x,fs,3,5);
[~,idx]=max(pm);
assert(abs(fm(idx)-8)<2)
a=aperiodic_slope(f,p,[2 120],[6 10;75 85]);
assert(isfinite(a.exponent))
peaks=spectral_peak_candidates(f,p);
assert(istable(peaks))
y=bandpass_lfp(x,fs,[5 12]);
[phase,amp]=analytic_phase(y);
assert(all(isfinite(phase)) && all(amp>=0))
[w,tw]=morlet_wavelet(x,fs,8,6);
assert(numel(w)==numel(x) && numel(tw)==numel(x))
surrogate=phase_randomized_surrogate(x);
assert(max(abs(abs(fft(x))-abs(fft(surrogate))))<1e-6)
cycles=cycle_by_cycle(y,fs);
assert(height(cycles)>60)
assert(abs(phase_locking_value(phase,phase)-1)<1e-10)
assert(abs(pairwise_phase_consistency(zeros(20,1))-1)<1e-10)
assert(phase_lag_index(pi/2*ones(10,1))==1)
assert(weighted_phase_lag_index(1i*(1:10))==1)
[mi,distribution,~]=modulation_index(phase,1+.5*cos(phase),18);
assert(isfinite(mi) && mi>0 && numel(distribution)==18)
[fc,coh]=coherence_spectrum(x,x,fs,2);
assert(numel(fc)==numel(coh) && max(coh) <= 1+1e-9)
[f_irasa,fractal,osc,total]=irasa_decomposition(x,fs,2);
assert(numel(f_irasa)==numel(fractal) && all(osc>=0) && all(total>=0))
[components,remainder]=empirical_mode_decomposition(x(1:500),3);
assert(max(abs(sum(components,2)+remainder-x(1:500)))<1e-8)
[em,rem]=ensemble_empirical_mode_decomposition(x(1:300),3,.1,2);
assert(size(em,1)==300 && max(abs(sum(em,2)+rem-x(1:300)))<1e-8)
assert(isfinite(permutation_entropy(x,3,2)))
assert(isfinite(spectral_entropy(p)))
csd=current_source_density((0:4)'.^2,1,1);
assert(abs(csd(3)+2)<1e-8)
[events]=ripple_candidate_events(x,fs,[120 200],2,5);
assert(istable(events))
[bin,center,edges]=spike_bin_counts([.1 .2 .9 1],0,1,.1);
assert(sum(bin)==3 && numel(center)==numel(bin) && numel(edges)==11)
assert(firing_rate([0 .2 1],0,1)==2)
assert(all(interspike_intervals([.5 .1 .2])>0))
[lag,ac]=autocorrelogram([.1 .2 .5],0,1,.01,.1);
assert(numel(lag)==numel(ac))
[lag,cc]=crosscorrelogram([.1 .2],[.11 .21],0,1,.01,.1);
assert(numel(lag)==numel(cc))
[centers,rate,by_trial]=peri_event_histogram([.05 1.05],[0 1],0:.1:.5);
assert(numel(centers)==numel(rate) && size(by_trial,1)==2)
assert(abs(spike_count_fano([1;2;3])-.5)<1e-10)
[ppc,spike_phase]=spike_field_ppc(y,[1.0 2.0 3.0],fs,.2);
assert(isfinite(ppc) && numel(spike_phase)==3)
sta=spike_triggered_average(x,[1 2 3],fs,.05,.05);
assert(numel(sta)==51)
wave=sin(linspace(0,2*pi,100));
assert(isfinite(waveform_trough_to_peak(wave,30000)))
model=population_pca([sin(t) cos(t)]);
assert(size(model.loadings,2)==2)
d=participation_ratio([sin(t) cos(t)]);
assert(d>=1 && d<=2+1e-8)
counts=round(3+4*rand(200,4));
model=assembly_pca(counts,2);
assert(size(model.templates,2)==2)
z=bsxfun(@rdivide,bsxfun(@minus,double(counts),model.mean),model.std);
activation=assembly_expression(z,model.templates);
assert(size(activation,2)==2)
nc=noise_correlation(counts,repmat([1;2],100,1));
assert(all(size(nc)==[4 4]))
pc=spike_waveform_pca(randn(20,50),3);
assert(size(pc.scores,2)==3)
broadband=.01*randn(30000,1); broadband(5000)=-5;
[~,loc]=spike_threshold_detection(broadband,30000,4,.001);
assert(any(loc==5000))
[id,sim]=template_match_waveforms(randn(4,20),randn(3,20));
assert(numel(id)==4 && numel(sim)==4)
assert(mutual_information([0;0;1;1],[0;0;1;1])>.9)
source=randi([0 1],300,1); target=[0;source(1:end-1)];
assert(transfer_entropy(source,target)>.2)
jitter=jitter_spike_surrogate([.01 .02 .21],.1);
assert(numel(jitter)==3)
ci=bootstrap_percentile([1;2;3;4],100,.90,42);
assert(ci(1)<=ci(2))
signflip=paired_signflip_test(zeros(15,1),ones(15,1),1000,7);
assert(signflip.p_two_sided<.01)
xg=randn(200,2);
g=granger_causality(xg,1,2,2);
assert(isfinite(g.log_variance_ratio))
glm=poisson_spike_glm(randn(50,2),double(rand(50,1)>.5),.1);
assert(all(isfinite(glm.coefficients)))
disp('arsenal smoke checks completed')

%% Regression checks: decimal bins, silence, missing spikes and half-open edges.
[bin,center,edges]=spike_bin_counts([0 .1 .2 .3 NaN Inf],0,.3,.1);
assert(isequal(bin,[1;1;1]) && numel(center)==3 && edges(end)==.3);
assert(isequal(spike_bin_counts([],0,.3,.1),zeros(3,1)));
[~,~,edges]=spike_bin_counts([],0,.35,.1);
assert(numel(edges)==4 && edges(end)<.35);
[centers,rate,by_trial]=peri_event_histogram([],[0 1],[0;.1;.3]);
assert(isequal(size(centers),[2 1]) && all(rate==0) && all(by_trial(:)==0));
[~,~,by_trial]=peri_event_histogram([0 .1 .3 NaN Inf],0,[0 .1 .3]);
assert(isequal(by_trial,[1 1]));
