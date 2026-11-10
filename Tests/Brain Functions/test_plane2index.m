%% test_plane2index
% Tests of the plane2index function.
%--------------------------------------------------------------------------

%% Third axis fixed, default gives a 3D index
index = plane2index([0, 0, 50]);
assert(isequal(index, {':', ':', 50}))

%% First axis fixed
index = plane2index([30, 0, 0]);
assert(isequal(index, {30, ':', ':'}))

%% extra = 1 gives a 4D index
index = plane2index([0, 20, 0], 1);
assert(isequal(index, {':', 20, ':', ':'}))

%% extra = 0 is the same as the default
assert(isequal(plane2index([0, 20, 0], 0), plane2index([0, 20, 0])))

%% The index extracts the right slice of an array
rng(2)
A = randn(4, 5, 6);
index = plane2index([0, 3, 0]);
assert(isequal(A(index{:}), A(:, 3, :)))
B = randn(4, 5, 6, 2);
index = plane2index([2, 0, 0], 1);
assert(isequal(B(index{:}), B(2, :, :, :)))
