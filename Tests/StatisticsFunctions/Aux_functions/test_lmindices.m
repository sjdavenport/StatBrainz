%% test_lmindices
% Tests of the lmindices function.
%--------------------------------------------------------------------------

%% 1D: a single maximum
[loc, ind, val] = lmindices([1, 3, 1]);
assert(loc == 2 && ind == 2 && val == 3)

%% 1D: top 2 maxima are sorted by value
[loc, ~, val] = lmindices([1, 2, 1, 4, 1], 2);
assert(isequal(loc(:)', [4, 2]) && isequal(val(:)', [4, 2]))

%% 1D: a mask excludes the boundary maximum
loc = lmindices([1, 2, 3], 1, [1, 1, 0]);
assert(isempty(loc) || loc ~= 3)

%% 2D: location and value
[loc, ind, val] = lmindices([1, 1, 1; 1, 2, 1; 1, 1, 1]);
assert(isequal(loc, [2; 2]) && ind == 5 && val == 2)

%% 3D: top 2 peaks
a = zeros([10, 12, 8]);
a(3, 4, 5) = 5;
a(8, 9, 2) = 3;
[loc, ind, val] = lmindices(a, 2);
assert(isequal(size(loc), [3, 2]))
assert(isequal(loc(:, 1), [3; 4; 5]) && isequal(loc(:, 2), [8; 9; 2]))
assert(isequal(a(ind), val) && isequal(val, [5; 3]))

%% top = 'all' returns all maxima
[~, ~, val] = lmindices([1, 2, 1, 3, 1, 4, 1], 'all');
assert(isequal(val(:)', [4, 3, 2]))

%% A mask of the wrong size gives an error
errored = 0;
try
    lmindices([1, 2, 1], 1, [1, 1]);
catch
    errored = 1;
end
assert(errored == 1)
