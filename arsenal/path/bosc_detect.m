function result = bosc_detect(signal,srate,frequencies,probability,minimum_cycles,wavelet_cycles)
%BOSC_DETECT Better OSCillation detection: wavelet power over 1/f background.
% Whitten et al. (2011) DOI:10.1016/j.neuroimage.2010.08.064.
% Hughes et al. (2012) DOI:10.1002/hipo.20979.
% This is a compact exploratory BOSC variant, not a validated eBOSC pipeline.
% x must be a finite real vector; frequencies in Hz; srate in Hz.
% Power threshold uses exponential (chi-square 2 df) marginal model.
% Bound the input by processing short time blocks; excludes wavelet edges.
if nargin<4 || isempty(probability), probability=.95; end
if nargin<5 || isempty(minimum_cycles), minimum_cycles=3; end
if nargin<6 || isempty(wavelet_cycles), wavelet_cycles=6; end
x=double(signal(:));
f=double(frequencies(:));
assert(numel(x)>=32 && all(isfinite(x)) && isreal(x));
assert(srate>0 && isfinite(srate) && numel(f)>=3 && ...
    all(isfinite(f)) && all(f>0 & f<srate/2) && ...
    all(diff(f)>0));
assert(probability>0 && probability<1 && ...
    minimum_cycles>0 && wavelet_cycles>=3);
n=numel(x); m=numel(f);
assert(n*m<=4e6,'Analyze a shorter time block or fewer frequencies');
power=nan(m,n);
valid=false(m,n);
mean_power=nan(m,1);
for k=1:m
    [coeff,~]=morlet_wavelet(x,srate,f(k),wavelet_cycles);
    edge=ceil(3.5*wavelet_cycles*srate/(2*pi*f(k)));
    assert(2*edge<n,'Time series too short for the lowest frequency');
    range=(edge+1):(n-edge);
    power(k,range)=abs(coeff(range)).^2;
    valid(k,range)=true;
    mean_power(k)=mean(power(k,range));
end
assert(all(mean_power>0),'Wavelet power must be positive');
% Single global log-log fit is sensitive to large periodic peaks.
background_model=polyfit(log(f),log(mean_power),1);
background=exp(polyval(background_model,log(f)));
threshold=-log(1-probability)*background;
mask=false(m,n);
fraction=nan(m,1);
episodes=cell(m,1);
for k=1:m
    above=power(k,:)>threshold(k) & valid(k,:);
    [events,keep,~]=oscillation_episode(above,srate,f(k),minimum_cycles);
    mask(k,:)=keep;
    fraction(k)=nnz(keep)/nnz(valid(k,:));
    episodes{k}=events;
end
result.frequency_hz=f;
result.time_seconds=(0:n-1)/srate;
result.wavelet_power=power;
result.mean_power=mean_power;
result.background_power=background;
result.power_threshold=threshold;
result.detected_mask=mask;
result.valid_mask=valid;
result.p_episode=fraction;
result.episodes=episodes;
result.background_slope=background_model(1);
result.parameters=struct('probability',probability, ...
    'minimum_cycles',minimum_cycles,'wavelet_cycles',wavelet_cycles);
result.note=['No iterative exclusion of oscillatory peaks and no nonstationary ' ...
    'background adaptation; inspect thresholds and false-positive rate'];
end
