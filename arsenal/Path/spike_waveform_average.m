function [template,sem] = spike_waveform_average(waveforms)
%SPIKE_WAVEFORM_AVERAGE Mean +/- SEM of aligned waveform snippets.
% Input spikes x channels x samples; outputs channels x samples.
assert(isnumeric(waveforms) && ndims(waveforms)==3 && size(waveforms,1)>=2);
assert(all(isfinite(waveforms(:))));
template=squeeze(mean(double(waveforms),1));
sem=squeeze(std(double(waveforms),0,1))/sqrt(size(waveforms,1));
end
