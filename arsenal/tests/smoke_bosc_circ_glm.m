%% Synthetic checks for BOSC, circular statistics and coupled GLM.
% MATLAB R2019a+, Signal Processing Toolbox. Not yet executed in MATLAB.
here=fileparts(mfilename('fullpath'));
addpath(fullfile(here,'..','Path'));
rng(21)
fs=500;
episodes_input=[false(30,1);true(200,1);false(20,1)];
[episodes,mask,fraction]=oscillation_episode(episodes_input,fs,10,3);
assert(height(episodes)==1)
assert(nnz(mask)==200 && abs(fraction-.8)<1e-12)
[episodes,mask]=oscillation_episode([false(30,1);true(50,1)],fs,10,3);
assert(isempty(episodes) && ~any(mask))
time=(0:fs*12-1)'/fs;
lfp=2*sin(2*pi*8*time)+.04*randn(size(time));
result=bosc_detect(lfp,fs,[4 6 8 12 16 24 40],.95,3,6);
assert(all(size(result.detected_mask)==[7 numel(lfp)]))
assert(all(result.power_threshold>0))
assert(all(result.p_episode>=0 & result.p_episode<=1))
assert(numel(result.episodes)==7)
[mu,r]=circular_mean([0;pi/2]);
assert(abs(mu-pi/4)<1e-12)
assert(abs(r-sqrt(2)/2)<1e-12)
[mu,r]=circular_mean([pi/2;-pi/2],[3;1]);
assert(abs(mu-pi/2)<1e-12 && abs(r-.5)<1e-12)
rv=rayleigh_test(zeros(100,1));
assert(rv.p_value<.01 && rv.resultant_length>.999)
rv=rayleigh_test((0:63)'*(2*pi/64));
assert(rv.p_value>.5)
counts=double(rand(400,3)<.15);
[design,valid_bins]=spike_history_design(counts,3);
assert(isequal(size(design),[397 9]))
assert(isequal(valid_bins,[4:400]'))
assert(design(1,1)==counts(3,1) && design(1,9)==counts(1,3))
fit=coupling_filters(counts,3,.01,5);
assert(isequal(size(fit.filters),[3 3 3]))
assert(isequal(size(fit.log_rate),[397 3]))
assert(all(isfinite(fit.filters(:))) && all(isfinite(fit.log_rate(:))))
disp('BOSC CircStat and coupled GLM synthetic checks completed')
