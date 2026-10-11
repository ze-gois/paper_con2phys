function projection = communication_subspace_projection(activity,model)
%COMMUNICATION_SUBSPACE_PROJECTION Coordinates of predictive source axes.
% Semedo et al. (2019); model from reduced_rank_regression on training.
x=double(activity);
assert(size(x,2)==numel(model.source_mean) && all(isfinite(x(:))));
projection=bsxfun(@minus,x,model.source_mean)*model.source_axes;
end
