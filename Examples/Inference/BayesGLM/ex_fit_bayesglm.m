%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the fit_bayesglm function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NB: fit_bayesglm is a partial port. The INLA fit is not implemented yet,
% so all of the outputs are empty.

%% Voxel data with the default hyperpriors
nT = 100; nV = 50;
BOLD = {randn(nT, nV)};
design = {randn(nT, 3)};
mask_qc.mask = true(nV, 1);
nuisance = [];
spatial = struct('spatial_type', 'voxel', 'labels', ones(nV, 1), ...
    'trans_mat', eye(4), 'trans_units', 'mm', 'nbhd_order', 1, ...
    'buffer', [], 'buffer_mask', [], 'data_loc', []);
[INLA_model_obj, field_estimates, hyperpar_posteriors] = ...
    fit_bayesglm(BOLD, design, mask_qc, nuisance, spatial);

%% Informative hyperpriors
[INLA_model_obj, field_estimates, hyperpar_posteriors] = ...
    fit_bayesglm(BOLD, design, mask_qc, nuisance, spatial, 'mean', 'informative');

%% Two sessions, without printing
BOLD = {randn(nT, nV), randn(nT, nV)};
design = {randn(nT, 3), randn(nT, 3)};
[INLA_model_obj, field_estimates, hyperpar_posteriors] = ...
    fit_bayesglm(BOLD, design, mask_qc, nuisance, spatial, 'mean', ...
    'default', 6, 5, false, 1, 'trimmed', 0);
