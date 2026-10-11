function factor = spike_count_fano(trial_counts)
%SPIKE_COUNT_FANO Variance-to-mean of spike counts across repeated trials.
% Each column is one unit/condition; mix conditions only with justification.
x=double(trial_counts);
assert(ismatrix(x) && size(x,1)>=2 && all(isfinite(x(:))) && all(x(:)>=0));
means=mean(x,1); factor=var(x,0,1)./means;
factor(means==0)=NaN;
end
