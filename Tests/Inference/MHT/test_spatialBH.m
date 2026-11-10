% Tests for spatialBH

%% Same result as one-sided p-values from mvtstat and fdrBH
rng(7)
dim = [8, 8]; nsubj = 20;
data = randn([dim, nsubj]);
data(1:4, 1:2, :) = data(1:4, 1:2, :) + 2;
[rej_locs, nrejections] = spatialBH(data, NaN);
pvals = 1 - tcdf(mvtstat(data), nsubj - 1);
[expected, nexpected] = fdrBH(pvals);
assert(isequal(size(rej_locs), dim))
assert(isequal(rej_locs, expected))
assert(nrejections == nexpected)
assert(sum(rej_locs(1:4, 1:2), 'all') >= 6)

%% One-sided: a strong negative signal is not rejected
data_neg = randn([dim, nsubj]);
data_neg(1:4, 1:2, :) = data_neg(1:4, 1:2, :) - 3;
rej_locs = spatialBH(data_neg, NaN);
assert(~any(rej_locs(1:4, 1:2), 'all'))

%% Smoothing with a FWHM is the same as smoothing first
FWHM = 2;
rej_smooth = spatialBH(data, FWHM);
expected = spatialBH(fast_conv(data, FWHM, 2), NaN);
assert(isequal(rej_smooth, expected))

%% FWHM is optional: without it no smoothing is done
rej_default = spatialBH(data);
assert(isequal(rej_default, spatialBH(data, NaN)))
