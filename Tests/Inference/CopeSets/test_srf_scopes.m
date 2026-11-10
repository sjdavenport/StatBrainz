% Tests for srf_scopes (calls scopes, which needs fastperm)

srf = loadsrf('fs4', 'white');
nvl = srf.lh.nvertices; nvr = srf.rh.nvertices;
rng(36)
nsubj = 20;
data.lh = randn(nvl, nsubj); data.rh = randn(nvr, nsubj) + 1;
mask.lh = true(nvl, 1); mask.rh = srf.rh.vertices(:, 2) > 0;

%% Same as scopes on the stacked data in the mask
rng(37); [lower_band, upper_band, threshold] = srf_scopes(data, mask, 100, 0.05, 0);
rng(37); [l, u, t] = scopes([data.lh; data.rh(mask.rh, :)], nsubj, 100, 0.05, 0);
assert(threshold == t)
assert(isequal(lower_band.lh, l(1:nvl)) && isequal(upper_band.rh(mask.rh), u(nvl+1:end)))

%% Sizes and zero outside the mask
assert(isequal(size(lower_band.rh), [nvr, 1]))
assert(~any(lower_band.rh(~mask.rh)) && ~any(upper_band.rh(~mask.rh)))
assert(all(lower_band.lh <= upper_band.lh))
