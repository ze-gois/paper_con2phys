function scaling = population_dimension_scaling(activity,unit_counts,repetitions,seed)
%POPULATION_DIMENSION_SCALING Participation ratio for sampled units.
% Williamson et al. (2016), doi:10.1371/journal.pcbi.1005141.
if nargin<3 || isempty(repetitions), repetitions=25; end
if nargin<4 || isempty(seed), seed=42; end
x=double(activity); [n,p]=size(x);
assert(n>=3 && p>=2 && all(isfinite(x(:))));
counts=double(unit_counts(:));
assert(~isempty(counts) && all(counts==floor(counts)) && ...
    all(counts>=2) && all(counts<=p));
assert(repetitions>=1 && repetitions==floor(repetitions));
stream=RandStream('mt19937ar','Seed',seed);
values=nan(repetitions,numel(counts));
for i=1:numel(counts)
    for k=1:repetitions
        [~,idx]=sort(rand(stream,1,p));
        values(k,i)=participation_ratio(x(:,idx(1:counts(i))));
    end
end
scaling.unit_counts=counts;
scaling.dimension_samples=values;
scaling.mean_dimension=mean(values,1)';
scaling.seed=seed;
end
