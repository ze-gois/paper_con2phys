function ci = bootstrap_percentile(values,draws,confidence,seed)
%BOOTSTRAP_PERCENTILE IID percentile CI of the arithmetic mean.
% Not valid for correlated bins/units without block or hierarchical resampling.
if nargin<2 || isempty(draws), draws=1000; end
if nargin<3 || isempty(confidence), confidence=.95; end
if nargin<4 || isempty(seed), seed=42; end
x=double(values(:)); x=x(isfinite(x));
assert(~isempty(x) && draws>=2 && confidence>0 && confidence<1);
stream=RandStream('mt19937ar','Seed',seed);
stats=zeros(draws,1);
for k=1:draws
    indices=randi(stream,numel(x),numel(x),1);
    stats(k)=mean(x(indices));
end
stats=sort(stats);
q=1+(draws-1)*[(1-confidence)/2,(1+confidence)/2];
ci=interp1(1:draws,stats,q,'linear');
end
