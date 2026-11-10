% Tests for imBH

%% Known rejections in an image with a full mask
% BH thresholds for m = 6 are 0.0083, 0.0167, 0.025, 0.0333, 0.0417, 0.05.
% The sorted p-values 1, 3 and 4 (0.033) are below them, so the 4 smallest are rejected.
pvals = [0.008, 0.024, 0.9; 0.02, 0.033, 0.7];
mask = true(2, 3);
[rejection_ind, n_rejections] = imBH(pvals, mask);
assert(isequal(size(rejection_ind), [2, 3]))
assert(isequal(logical(rejection_ind), pvals < 0.5))
assert(n_rejections == 4)

%% Same result as fdrBH on the vector of p-values
rng(2)
pvals = rand(8, 8);
pvals(1:5, 1) = 1e-5;
[rejection_ind, n_rejections] = imBH(pvals, true(8, 8));
assert(isequal(logical(rejection_ind), fdrBH(pvals)))
assert(n_rejections == sum(fdrBH(pvals(:))))

%% No rejections gives an image of zeros
[rejection_ind, n_rejections] = imBH(ones(4, 5), true(4, 5));
assert(isequal(size(rejection_ind), [4, 5]))
assert(~any(rejection_ind(:)))
assert(n_rejections == 0)

%% Only the p-values in the mask are considered
% In the mask, m = 3 and p = 0.01 <= 0.05/3, so it is rejected.
pvals = [0.01, 0.6; 0.0001, 0.7];
mask = logical([1, 1; 0, 1]);
[rejection_ind, n_rejections] = imBH(pvals, mask);
assert(rejection_ind(1, 1) == 1)
% the small p-value outside of the mask must not be rejected
assert(rejection_ind(2, 1) == 0)
assert(n_rejections == 1)

%% Error if the mask has a different size
try
    imBH(rand(3, 4), true(3, 5));
    errored = 0;
catch e
    errored = contains(e.message, 'size of pvals');
end
assert(errored == 1)
