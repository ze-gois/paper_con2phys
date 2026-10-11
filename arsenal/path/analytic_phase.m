function [phase, amplitude, analytic] = analytic_phase(signal)
%ANALYTIC_PHASE Hilbert analytic signal, phase (rad), amplitude (input units).
% Bruns (2004). Apply a scientifically justified bandpass beforehand.
validateattributes(signal,{'numeric'},{'vector','real','finite','nonempty'});
analytic=hilbert(double(signal));
amplitude=abs(analytic);
phase=angle(analytic);
end
