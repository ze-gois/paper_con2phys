function result = paired_signflip_test(before,after,draws,seed)
%PAIRED_SIGNFLIP_TEST Two-sided paired sign-flip randomization test.
% Maris & Oostenveld (2007) motivate permutation inference; NOT cluster-based.
if nargin<3 || isempty(draws), draws=2000; end
if nargin<4 || isempty(seed), seed=42; end
a=double(before(:)); b=double(after(:));
assert(numel(a)==numel(b) && numel(a)>=2 && all(isfinite(a)) && ...
    all(isfinite(b)) && draws>=1);
delta=b-a; observed=mean(delta);
stream=RandStream('mt19937ar','Seed',seed);
extreme=0;
for k=1:draws
    signs=2*(rand(stream,numel(delta),1)>.5)-1;
    extreme=extreme+(abs(mean(delta.*signs))>=abs(observed));
end
result.observed_difference=observed;
result.p_two_sided=(1+extreme)/(draws+1);
result.draws=draws;
end
