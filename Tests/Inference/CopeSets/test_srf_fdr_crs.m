% Tests for srf_fdr_crs

srf = loadsrf('fs4', 'white');
nvl = srf.lh.nvertices; nvr = srf.rh.nvertices;
rng(35)
nsubj = 20; c = 0;
data.lh = randn(nvl, nsubj) + linspace(-3, 3, nvl)';
data.rh = randn(nvr, nsubj) + linspace(3, -3, nvr)';
mask.lh = true(nvl, 1); mask.rh = true(nvr, 1);

%% Same as fdr_crs on the stacked data
[lower_set, upper_set] = srf_fdr_crs(data, mask, c);
[l, u] = fdr_crs([data.lh; data.rh], c);
assert(isequal(lower_set.lh, double(l(1:nvl))) && isequal(lower_set.rh, double(l(nvl+1:end))))
assert(isequal(upper_set.lh, double(u(1:nvl))) && isequal(upper_set.rh, double(u(nvl+1:end))))
assert(isequal(size(lower_set.lh), [nvl, 1]))

%% The upper set is inside the lower set
assert(all(lower_set.lh >= upper_set.lh) && all(lower_set.rh >= upper_set.rh))

%% Zero outside the mask
mask.lh = srf.lh.vertices(:, 2) > 0; mask.rh = srf.rh.vertices(:, 2) > 0;
[lower_set, upper_set] = srf_fdr_crs(data, mask, c, 0.1);
assert(~any(lower_set.lh(~mask.lh)) && ~any(upper_set.rh(~mask.rh)))
[l, u] = fdr_crs([data.lh(mask.lh, :); data.rh(mask.rh, :)], c, 0.1);
assert(isequal(lower_set.lh(mask.lh), double(l(1:sum(mask.lh)))))

%% Error if thresh is not a single number
try
    srf_fdr_crs(data, mask, [0, 1]);
    errored = 0;
catch e
    errored = contains(e.message, 'Thresh must be a single number');
end
assert(errored == 1)
