% Tests for fdr_crs

rng(24)
dim = [10, 12]; nsubj = 30; c = 1;
mu = repmat(linspace(-2, 4, dim(2)), dim(1), 1);
data = mu + randn([dim, nsubj]);

%% Output sizes and type
[lower_set, upper_set] = fdr_crs(data, c);
assert(isequal(size(lower_set), dim) && isequal(size(upper_set), dim))
assert(islogical(lower_set) && islogical(upper_set))

%% The upper set is inside the lower set
assert(all(lower_set(:) >= upper_set(:)))

%% Far above c is in the upper set and far below c is not in the lower set
assert(all(upper_set(:, end)))
assert(~any(lower_set(:, 1)))

%% Same as BH on both one-sided p-values with level 2*alpha
tstat = mvtstat(data - c);
pvals = 1 - tcdf(tstat, nsubj - 1);
allp = [pvals(:), 1 - pvals(:)];
rej = fdrBH(allp, 0.1);
maxp = max(allp(rej));
assert(isequal(upper_set, pvals <= maxp + eps))
assert(isequal(lower_set, ~((1 - pvals) <= maxp + eps)))

%% Default alpha is 0.05 and a larger alpha gives tighter sets
[l1, u1] = fdr_crs(data, c, 0.05);
assert(isequal(l1, lower_set) && isequal(u1, upper_set))
[l2, u2] = fdr_crs(data, c, 0.3);
assert(sum(u2(:)) >= sum(upper_set(:)))
assert(sum(l2(:)) <= sum(lower_set(:)))

%% Error if thresh is not a single number
try
    fdr_crs(data, [1, 2]);
    errored = 0;
catch e
    errored = contains(e.message, 'Thresh must be a single number');
end
assert(errored == 1)
