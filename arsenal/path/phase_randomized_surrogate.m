function surrogate = phase_randomized_surrogate(signal)
%PHASE_RANDOMIZED_SURROGATE Real-valued Fourier phase randomization.
% Preserves Fourier magnitudes, not transient structure or nonstationarity.
% Uses caller's random state; seed explicitly outside this function.
assert(isvector(signal) && isreal(signal) && all(isfinite(signal)));
was_row=isrow(signal); x=double(signal(:)); n=numel(x);
assert(n>=4,'At least 4 samples required');
spec=fft(x);
positive=2:floor((n+1)/2);
angles=2*pi*rand(numel(positive),1);
spec(positive)=abs(spec(positive)).*exp(1i*angles);
spec(n-positive+2)=conj(spec(positive));
surrogate=real(ifft(spec));
if was_row, surrogate=surrogate.'; end
end
