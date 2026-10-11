function cycles = cycle_by_cycle(filtered,srate)
%CYCLE_BY_CYCLE Describe individual cycles from a prefiltered oscillation.
% Cole & Voytek (2019), simplified cycle descriptors only.
% This does NOT reproduce the burst detection or quality criteria in bycycle.
validateattributes(filtered,{'numeric'},{'vector','real','finite'});
assert(srate>0,'srate must be positive');
x=double(filtered(:));
up=find(x(1:end-1)<=0 & x(2:end)>0);
n=max(0,numel(up)-1);
onset=zeros(n,1); period=zeros(n,1); amp=zeros(n,1);
for k=1:n
    a=up(k); b=up(k+1);
    y=x(a:b);
    onset(k)=(a-1)/srate;
    period(k)=(b-a)/srate;
    amp(k)=(max(y)-min(y))/2;
end
frequency=1./period;
cycles=table(onset,period,frequency,amp, ...
    'VariableNames',{'onset_s','period_s','frequency_hz','half_peak_to_peak'});
end
