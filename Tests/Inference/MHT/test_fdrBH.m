% Tests for fdrBH

%% Known BH rejections, including the step-up rescue of p-values 2 and 3
% BH thresholds for m = 5, alpha = 0.05 are 0.01, 0.02, 0.03, 0.04, 0.05.
% Only p(1) and p(4) are below their thresholds, so the first 4 are rejected.
pvalues = [0.039, 0.9, 0.005, 0.035, 0.03];
[rejection_ind, nrejections, rejection_locs, maxp] = fdrBH(pvalues);
assert(isequal(rejection_ind, logical([1, 0, 1, 1, 1])))
assert(nrejections == 4)
assert(isequal(rejection_locs, [1, 3, 4, 5]))
assert(maxp == 0.039)

%% Default alpha is 0.05
assert(isequal(fdrBH(pvalues), fdrBH(pvalues, 0.05)))

%% A smaller alpha gives fewer rejections
% Thresholds for alpha = 0.01 are 0.002, 0.004, ..., 0.01: none are met
[~, nrej] = fdrBH(pvalues, 0.01);
assert(nrej == 0)

%% The output has the same shape as the input
rng(1)
P = rand(4, 6);
P(1:3) = 1e-6;
[rejection_ind, nrejections] = fdrBH(P);
assert(isequal(size(rejection_ind), [4, 6]))
assert(islogical(rejection_ind))
assert(nrejections == sum(rejection_ind(:)))
assert(all(rejection_ind(1:3)))

%% BY is more conservative than BH
% BY alpha = 0.05/sum(1./(1:5)) = 0.0219, thresholds 0.0044, 0.0088, 0.0131, ...
pvalues = [0.001, 0.008, 0.015, 0.5, 0.9];
[~, nrej_bh] = fdrBH(pvalues, 0.05, 0);
[rej_by, nrej_by] = fdrBH(pvalues, 0.05, 1);
assert(nrej_bh == 3)
assert(nrej_by == 2)
assert(isequal(rej_by, logical([1, 1, 0, 0, 0])))

%% No rejections
[rejection_ind, nrejections, rejection_locs, maxp] = fdrBH(ones(1, 5));
assert(~any(rejection_ind))
assert(nrejections == 0)
assert(isempty(rejection_locs))
assert(isempty(maxp))

%% All p-values zero are all rejected
[rejection_ind, nrejections] = fdrBH(zeros(1, 7));
assert(all(rejection_ind))
assert(nrejections == 7)
