%% test_convindall
% Tests of the convindall function.
%--------------------------------------------------------------------------

%% Cell array input with the default MNI size
out = convindall({[358390, 358389], 358380});
assert(iscell(out) && length(out) == 2)
assert(isequal(out{1}, [32,15,37; 31,15,37]))
assert(isequal(out{2}, [22,15,37]))

%% Numeric input is wrapped into a cell
out = convindall([358390, 358389]);
assert(iscell(out) && length(out) == 1)
assert(isequal(out{1}, [32,15,37; 31,15,37]))

%% Agrees with ind2sub for a 2D size
rng(1)
dim = [20,30];
inds = randi(prod(dim), 1, 15);
out = convindall({inds}, dim);
[x, y] = ind2sub(dim, inds);
assert(isequal(out{1}, [x(:), y(:)]))

%% Output sizes
out = convindall({1:4, 5, 6:7}, [10,10,10]);
assert(isequal(size(out{1}), [4,3]) && isequal(size(out{2}), [1,3]) && isequal(size(out{3}), [2,3]))

%% An empty cell entry gives an empty matrix with D columns
out = convindall({[]}, [10,10,10]);
assert(isequal(size(out{1}), [0,3]))
