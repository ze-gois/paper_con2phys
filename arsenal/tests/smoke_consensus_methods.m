%% Synthetic checks for new Consensus-derived estimators.
% Not executed in authoring environment. MATLAB R2019a+.
here=fileparts(mfilename('fullpath'));
addpath(fullfile(here,'..','path'));
spikes=[.1 .3 .8];
assert(victor_purpura_distance(spikes,spikes,10)==0)
assert(victor_purpura_distance([],spikes,1)==3)
assert(abs(victor_purpura_distance(.1,.2,5)-.5)<1e-12)
assert(victor_purpura_distance(.1,.2,100)==2)
theta=(0:999)'*2*pi/1000;
flat=pac_mean_vector_length(theta,ones(size(theta)));
assert(flat.raw_mvl<1e-12)
coupled=pac_mean_vector_length(theta,1+.6*cos(theta));
assert(abs(coupled.raw_mvl-.3)<1e-10)
assert(abs(coupled.normalized_mvl-.3)<1e-10)
disp('Consensus methods synthetic checks completed')
