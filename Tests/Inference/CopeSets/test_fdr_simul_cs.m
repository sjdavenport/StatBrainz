% Tests for fdr_simul_cs

rng(33)
dim = [10, 12]; nsubj = 30;
mu = repmat(linspace(-2, 4, dim(2)), dim(1), 1);
data = mu + randn([dim, nsubj]);
mask = ones(dim);

%% Output sizes and the upper set is inside the lower set
[lower_set, upper_set] = fdr_simul_cs(data, mask, [0, 1, 2]);
assert(isequal(size(lower_set), dim) && isequal(size(upper_set), dim))
assert(all(lower_set(:) >= upper_set(:)))

%% One threshold: far above it is in the upper set, far below is not in the lower set
[lower_set, upper_set] = fdr_simul_cs(data, mask, 1);
assert(all(upper_set(:, end)))
assert(~any(lower_set(:, 1)))

%% Default alpha is 0.05
[l1, u1] = fdr_simul_cs(data, mask, 1);
[l2, u2] = fdr_simul_cs(data, mask, 1, 0.05);
assert(isequal(l1, l2) && isequal(u1, u2))
