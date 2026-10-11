%% Synthetic population geometry checks (MATLAB R2019a+)
% Run from repository root: run('arsenal/tests/smoke_population.m')
% No MATLAB execution was performed in the authoring environment.
here=fileparts(mfilename('fullpath'));
addpath(fullfile(here,'..','Path'))
rng(17);
lambda=(1:20)'.^(-1.5);
fit=eigenspectrum_powerlaw(lambda,(2:17)');
assert(abs(fit.exponent-1.5)<1e-10);
x=randn(120,12);
scale=population_dimension_scaling(x,[3 6 12],6,42);
assert(isequal(size(scale.dimension_samples),[6 3]));
assert(all(scale.mean_dimension>=1));
labels=[zeros(60,1);ones(60,1)];
activity=randn(120,6);
activity(61:end,1)=activity(61:end,1)+5;
activity(:,2)=activity(:,2)+3*randn(120,1);
condition=condition_marginalization(activity,labels);
assert(size(condition.condition_means,1)==2);
assert(norm(mean(condition.noise_residual,1))<1e-10);
d=targeted_dimensionality_reduction(activity,labels);
assert(isequal(size(d.basis),[6 2]));
assert(norm(d.basis'*d.basis-eye(2),'fro')<1e-9);
discr=linear_discriminability(activity(1:60,:),activity(61:end,:),.1);
assert(discr.dprime_squared>0);
decoded=crossvalidated_ridge_decoder(activity,labels,5,1);
assert(decoded.accuracy>.95);
source=randn(180,5);
target=[2*source(:,1)-source(:,2), source(:,1)+source(:,3), ...
        .2*randn(180,1)];
rrr=reduced_rank_regression(source,target,2,.01);
assert(isequal(size(rrr.coefficients),[5 3]));
assert(norm(rrr.coefficients,'fro')>0);
assert(rank(rrr.coefficients,1e-8)<=2);
projection=communication_subspace_projection(source,rrr);
assert(isequal(size(projection),[180 2]));
dt=.005;
t=(0:400)'*dt;
trajectory=[cos(2*pi*t) sin(2*pi*t)];
rot=jpca_dynamics(trajectory,dt);
assert(norm(rot.generator+rot.generator','fro')<1e-10);
assert(rot.residual_fraction<.01);
tensor=zeros(7,10,6);
for r=1:2
    a=randn(7,1); b=randn(10,1); c=randn(6,1);
    tensor=tensor+reshape(a,[],1,1).*reshape(b,1,[],1).*reshape(c,1,1,[]);
end
cp=tensor_cp_als(tensor,2,50,1e-6);
assert(all(isfinite(cp.neuron_factors(:))));
assert(isfinite(cp.relative_error) && cp.relative_error<1);
signal=[sin(t) cos(t)]+.05*randn(numel(t),2);
gp=gaussian_process_smoothing(signal(1:80,:),t(1:80),.1,1,.1);
assert(isequal(size(gp.smoothed),[80 2]));
assert(all(isfinite(gp.smoothed(:))));
disp('population arsenal smoke checks completed')
