function peaks = spectral_peak_candidates(frequency,power,width_hz,prominence_db)
%SPECTRAL_PEAK_CANDIDATES Find local excess above a median spectral baseline.
% Heuristic complement to Donoghue et al. (2020); NOT aperiodic peak fitting.
if nargin<3 || isempty(width_hz), width_hz=10; end
if nargin<4 || isempty(prominence_db), prominence_db=3; end
f=double(frequency(:)); p=double(power(:));
assert(numel(f)==numel(p) && numel(f)>=4 && all(diff(f)>0), ...
    'Expected ascending frequency and matching PSD');
db=10*log10(max(p,realmin));
df=median(diff(f));
n=max(3,2*floor(width_hz/(2*df))+1);
background=movmedian(db,n);
excess=db-background;
[height,location]=findpeaks(excess,f,'MinPeakProminence',prominence_db);
keep=height>=prominence_db;
peaks=table(location(keep),height(keep), ...
    interp1(f,p,location(keep)), ...
    'VariableNames',{'frequency_hz','excess_db','power'});
end
