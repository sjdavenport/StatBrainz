% Tests for perm_thresh

rng(18)
dim = [4, 5]; nsubj = 15; niters = 200;
data = randn([dim, nsubj]);
data(1, 1, :) = data(1, 1, :) + 4;

%% Output sizes and the threshold is the 95% quantile of the maxima
[im_perm, threshold, vec_of_maxima] = perm_thresh(data, 'T', 0, 0, 0.05, NaN, NaN, 0, niters);
assert(isequal(size(im_perm), dim))
assert(isequal(size(vec_of_maxima), [1, niters]))
assert(abs(threshold - prctile(vec_of_maxima, 95)) < 1e-12)

%% The original statistic is the first permutation and im_perm is the excursion set
tstat = mvtstat(data);
assert(abs(vec_of_maxima(1) - max(tstat(:))) < 1e-12)
assert(isequal(im_perm, tstat > threshold))
assert(im_perm(1, 1) == 1)

%% The Z statistic uses the mean
[im_perm, threshold, vec_of_maxima] = perm_thresh(data, 'Z', 0, 0, 0.05, NaN, NaN, 0, niters);
xbar = mean(data, 3);
assert(abs(vec_of_maxima(1) - max(xbar(:))) < 1e-12)
assert(isequal(im_perm, xbar > threshold))

%% Two-sided test uses the absolute value
data2 = data; data2(2, 2, :) = data2(2, 2, :) - 6;
[im_perm, threshold, vec_of_maxima] = perm_thresh(data2, 'T', 1, 0, 0.05, NaN, NaN, 0, niters);
assert(all(vec_of_maxima(2:end) >= 0))
assert(isequal(im_perm, abs(mvtstat(data2)) > threshold))
assert(im_perm(2, 2) == 1)

%% Without the original sample
rng(19)
[~, ~, vec_of_maxima] = perm_thresh(data, 'T', 0, 0, 0.05, NaN, NaN, 0, niters, 0);
assert(isequal(size(vec_of_maxima), [1, niters]))

%% Defaults: stat T, alpha 0.05 and 1000 permutations
rng(20)
[~, threshold, vec_of_maxima] = perm_thresh(data);
assert(isequal(size(vec_of_maxima), [1, 1000]))
assert(abs(threshold - prctile(vec_of_maxima, 95)) < 1e-12)

%% 1D data: the threshold is close to the normal quantile
rng(21)
data1 = randn(1, 200);
[~, threshold] = perm_thresh(data1, 'Z', 0, 0, 0.05, NaN, NaN, 0, 2000);
assert(abs(threshold - 1.645*std(data1)/sqrt(200)) < 0.03)

%% The mask is used for the original maximum
mask = false(dim); mask(3:4, 3:5) = 1;
[~, ~, vec_of_maxima] = perm_thresh(data, 'T', 0, 0, 0.05, NaN, mask, 0, niters);
assert(abs(vec_of_maxima(1) - max(tstat(mask))) < 1e-12)
