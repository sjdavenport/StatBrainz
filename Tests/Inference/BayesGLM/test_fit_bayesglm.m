% Tests for fit_bayesglm (a partial port: the INLA fit is not implemented)

rng(23)
nT = 30; nV = 8;
BOLD = {randn(nT, nV)};
design = {randn(nT, 2)};
mask_qc.mask = true(nV, 1);
spatial = struct('spatial_type', 'voxel', 'labels', ones(nV, 1), ...
    'trans_mat', eye(4), 'trans_units', 'mm', 'nbhd_order', 1, ...
    'buffer', [], 'buffer_mask', [], 'data_loc', []);

%% The call runs and the outputs are empty (not implemented yet)
[a, b, c] = fit_bayesglm(BOLD, design, mask_qc, [], spatial, 'mean', 'default', 2, 0, false, 1, 'trimmed', 0);
assert(isempty(a) && isempty(b) && isempty(c))

%% Informative hyperpriors run
[a, b, c] = fit_bayesglm(BOLD, design, mask_qc, [], spatial, 'mean', 'informative', 2, 0, false, 1, 'trimmed', 0);
assert(isempty(a))

%% Error for unknown hyperpriors
try
    fit_bayesglm(BOLD, design, mask_qc, [], spatial, 'mean', 'bad');
    errored = 0;
catch e
    errored = contains(e.message, 'hyperpriors');
end
assert(errored == 1)

%% Error if spatial is not a struct
try
    fit_bayesglm(BOLD, design, mask_qc, [], 1);
    errored = 0;
catch e
    errored = contains(e.message, 'spatial must be a struct');
end
assert(errored == 1)

%% Error for an unknown spatial type
try
    fit_bayesglm(BOLD, design, mask_qc, [], struct('spatial_type', 'other'));
    errored = 0;
catch e
    errored = contains(e.message, 'Unknown spatial.spatial_type');
end
assert(errored == 1)

%% Error if no location passes the QC mask
try
    fit_bayesglm(BOLD, design, struct('mask', false(nV, 1)), [], spatial);
    errored = 0;
catch e
    errored = contains(e.message, 'No locations');
end
assert(errored == 1)
