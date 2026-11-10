% Tests for imBH_data

%% Same result as two-sided p-values from mvtstat and fdrBH
rng(4)
dim = [6, 7]; nsubj = 20;
data = randn([dim, nsubj]);
data(1:3, 1, :) = data(1:3, 1, :) + 3;
data(4, 1, :) = data(4, 1, :) - 3;
mask = true(dim);
[rejection_ind, n_rejections] = imBH_data(data, mask);
pvals = 2*(1 - tcdf(abs(mvtstat(data)), nsubj - 1));
assert(isequal(size(rejection_ind), dim))
assert(isequal(logical(rejection_ind), fdrBH(pvals)))
assert(n_rejections == sum(rejection_ind(:)))

%% Two-sided: strong positive and strong negative signal are both found
assert(all(rejection_ind(1:4, 1)))

%% No signal gives no rejections and an image of size dim
rng(5)
data = randn([5, 5, 10]);
data(1, 1, :) = [1, -1, 1, -1, 1, -1, 1, -1, 1, -1];
[rejection_ind, n_rejections] = imBH_data(data, true(5, 5));
assert(isequal(size(rejection_ind), [5, 5]))
assert(n_rejections == sum(rejection_ind(:)))

%% Only the locations in the mask are considered
rng(6)
data = randn([4, 4, 20]);
data(1, 1, :) = data(1, 1, :) + 5;   % in the mask
data(4, 4, :) = data(4, 4, :) + 20;  % outside the mask, smallest p-value
mask = true(4, 4); mask(4, 4) = 0;
rejection_ind = imBH_data(data, mask);
assert(rejection_ind(1, 1) == 1)
assert(rejection_ind(4, 4) == 0)
