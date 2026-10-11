function [mi,amplitude_by_phase,edges] = modulation_index(phase,amplitude,nbins)
%MODULATION_INDEX Tort et al. (2010) phase-amplitude modulation index.
% Inputs are low-frequency phase (rad) and high-frequency envelope.
% This is descriptive: use surrogates and control waveform non-sinusoidality.
if nargin<3 || isempty(nbins), nbins=18; end
phase=double(phase(:)); amplitude=double(amplitude(:));
assert(numel(phase)==numel(amplitude),'Phase and amplitude must match');
assert(nbins>=3 && nbins==floor(nbins),'nbins must be integer >= 3');
valid=isfinite(phase)&isfinite(amplitude)&amplitude>=0;
phase=mod(phase(valid)+pi,2*pi)-pi; amplitude=amplitude(valid);
edges=linspace(-pi,pi,nbins+1);
assert(numel(phase)>=2*nbins,'Insufficient observations');
index=discretize(phase,edges);
amplitude_by_phase=nan(nbins,1);
for k=1:nbins
    values=amplitude(index==k);
    if ~isempty(values), amplitude_by_phase(k)=mean(values); end
end
if any(~isfinite(amplitude_by_phase)) || sum(amplitude_by_phase)==0
    mi=NaN; return
end
prob=amplitude_by_phase/sum(amplitude_by_phase);
prob=prob(prob>0);
mi=(log(nbins)+sum(prob.*log(prob)))/log(nbins);
end
