% Tests for bayespw (the function in the file is GLM_est_resid_var_pw)

rng(22)
nT = 40; nV = 6;
BOLD = {randn(nT, nV), 2*randn(nT, nV)};
design = {randn(nT, 2), randn(nT, 2)};
spatial = randn(3, nV);
names = {'s1', 's2'};
fields = {'a', 'b'};

%% No prewhitening: residual variance per session
results = bayespw(BOLD, design, spatial, names, fields, 'regular', ...
    true(2, 2), nT, 2, 0, 0, 1, 0);
for s = 1:2
    resid = BOLD{s} - design{s}*(design{s}\BOLD{s});
    assert(max(abs(results.var_resid(:, s) - var(resid)')) < 1e-10)
end
assert(isequal(size(results.var_resid), [nV, 2]))

%% No prewhitening: averaged variance is scaled to have mean 1
v = mean(results.var_resid, 2);
assert(max(abs(results.var_avg - v/mean(v))) < 1e-10)
assert(abs(mean(results.var_avg) - 1) < 1e-10)
assert(isempty(results.AR_coefs_avg))
assert(isempty(results.max_AIC))

%% No prewhitening: sqrtInv_all is diagonal with entries 1/sqrt(var_avg)
nTs = [nT, 10];
results = bayespw(BOLD, design, spatial, names, fields, 'regular', ...
    true(2, 2), nTs, 2, 0, 0, 1, 0);
assert(iscell(results.sqrtInv_all) && numel(results.sqrtInv_all) == 2)
M = results.sqrtInv_all{2};
assert(isequal(size(M), [10*nV, 10*nV]))
assert(max(abs(diag(M) - repmat(1./sqrt(results.var_avg), 10, 1))) < 1e-10)
assert(nnz(M) == 10*nV)

%% Per location design
design_loc = {randn(nT, 2, nV), randn(nT, 2, nV)};
results = bayespw(BOLD, design_loc, spatial, names, fields, 'per_location', ...
    true(2, 2), nT, 2, 0, 0, 1, 0);
d = design_loc{1}(:, :, 3);
resid = BOLD{1}(:, 3) - d*(d\BOLD{1}(:, 3));
assert(abs(results.var_resid(3, 1) - var(resid)) < 1e-10)

%% Prewhitening: sizes of the AR coefficients and sqrtInv_all
ar_order = 2;
results = bayespw(BOLD, design, spatial, names, fields, 'regular', ...
    true(2, 2), nT, ar_order, 0, 0, 1, 1);
assert(isequal(size(results.AR_coefs_avg), [nV, ar_order]))
assert(isequal(size(results.sqrtInv_all{1}), [nT*nV, nT*nV]))

%% An invalid design type gives an error
try
    bayespw(BOLD, design, spatial, names, fields, 'bad', true(2, 2), nT, 2, 0, 0, 1, 0);
    errored = 0;
catch e
    errored = contains(e.message, 'Invalid design type');
end
assert(errored == 1)
