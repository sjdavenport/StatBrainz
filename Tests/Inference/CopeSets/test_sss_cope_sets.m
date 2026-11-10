% Tests for sss_cope_sets

rng(25)
dim = [20, 20]; nsubj = 40; c = 2;
mu = repmat(linspace(1, 3, dim(2)), dim(1), 1);
data = mu + randn([dim, nsubj])*0.5;
mask = ones(dim);

%% Output sizes and the upper set is inside the lower set
[lower_set, upper_set, std_multipler] = sss_cope_sets(data, mask, c, 200);
assert(isequal(size(lower_set), dim) && isequal(size(upper_set), dim))
assert(all(lower_set(:) >= upper_set(:)))
assert(isscalar(std_multipler) && std_multipler > 0)

%% The sets are the mean compared with c -/+ std_multipler*std
xbar = mean(data, 3); sd = std(data, 0, 3);
assert(isequal(logical(lower_set), xbar >= c - std_multipler*sd))
assert(isequal(logical(upper_set), xbar >= c + std_multipler*sd))

%% Far above c is in the upper set and far below c is not in the lower set
assert(all(upper_set(:, end)))
assert(~any(lower_set(:, 1)))

%% The sets are zero outside the mask
mask2 = mask; mask2(:, 15:end) = 0;
[lower_set, upper_set] = sss_cope_sets(data, mask2, c, 200);
assert(~any(lower_set(:, 15:end), 'all') && ~any(upper_set(:, 15:end), 'all'))

%% Default number of bootstraps and quantile
rng(26); [l1, u1, m1] = sss_cope_sets(data, mask, c);
rng(26); [l2, u2, m2] = sss_cope_sets(data, mask, c, 1000, 0.95);
assert(isequal(l1, l2) && isequal(u1, u2) && m1 == m2)

%% A higher quantile gives a larger multiplier
rng(27); [~, ~, m95] = sss_cope_sets(data, mask, c, 500, 0.95);
rng(27); [~, ~, m50] = sss_cope_sets(data, mask, c, 500, 0.5);
assert(m95 > m50)

%% 3D data
rng(28)
dim3 = [8, 8, 8];
mu3 = repmat(reshape(linspace(1, 3, 8), [1, 1, 8]), 8, 8, 1);
data3 = mu3 + randn([dim3, 30])*0.5;
[lower_set, upper_set] = sss_cope_sets(data3, ones(dim3), 2, 100);
assert(isequal(size(lower_set), dim3))
assert(all(lower_set(:) >= upper_set(:)))

%% No boundary gives NaN outputs (and the warning 'No boundary found')
[lower_set, upper_set, std_multipler] = sss_cope_sets(data + 10, mask, c, 50);
assert(isnan(lower_set) && isnan(upper_set) && isnan(std_multipler))
