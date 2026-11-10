% Tests for localized_vi

%% Known maxima and p-values
tstat = [1, 2; 3, 4];
masks = {logical([1, 0; 0, 0]), logical([0, 0; 1, 1])};
vec_of_maxima = 0.5:0.5:5;   % 10 values
[pvals, max_t] = localized_vi(tstat, masks, vec_of_maxima);
assert(isequal(max_t, [1, 4]))
% p = proportion of maxima >= the observed maximum
assert(all(abs(pvals - [0.9, 0.3]) < 1e-12))
assert(isequal(size(pvals), [1, 2]))

%% A single mask that is not in a cell
[pvals, max_t] = localized_vi(tstat, logical([1, 1; 0, 0]), vec_of_maxima);
assert(max_t == 2)
assert(abs(pvals - 0.7) < 1e-12)

%% NaN values are ignored
tstat_nan = [NaN, 2; 3, 4];
[~, max_t] = localized_vi(tstat_nan, {true(2, 2)}, vec_of_maxima);
assert(max_t == 4)

%% Large maximum gives p-value 0
[pvals, max_t] = localized_vi([10, 0; 0, 0], {true(2, 2)}, vec_of_maxima);
assert(max_t == 10)
assert(pvals == 0)

%% The maximum is taken over the region only
% All t-values in the region are negative, so the maximum is -1.
tstat = [-1, -2; 3, 4];
[~, max_t] = localized_vi(tstat, {logical([1, 1; 0, 0])}, vec_of_maxima);
assert(max_t == -1)
