%% test_convind
% Tests of the convind function.
%--------------------------------------------------------------------------

%% Coordinates to a linear index in the default MNI size
% 32 + (15-1)*91 + (37-1)*91*109 = 358390
assert(convind([32,15,37]) == 358390)

%% Linear index to coordinates in the default MNI size
assert(isequal(convind(358390), [32,15,37]))

%% Round trip agrees with ind2sub and sub2ind in 2D
dim = [250,250];
assert(convind([13,15], dim) == 13 + 14*250)
assert(isequal(convind(3513, dim), [13,15]))
rng(1)
for ind = randi(prod(dim), 1, 10)
    [x, y] = ind2sub(dim, ind);
    assert(isequal(convind(ind, dim), [x,y]))
    assert(convind([x,y], dim) == ind)
end

%% conv2what = 1 gives fsleyes (zero based) indices
assert(isequal(convind(358390, [91,109,91], 1), [31,14,36]))

%% conv2what = 2 gives aligned anatomical coordinates
% [90 - 2*31, 2*14 - 126, 2*36 - 72]
assert(isequal(convind(358390, [91,109,91], 2), [28,-98,0]))

%% Default conv2what is 0
assert(isequal(convind(358390, [91,109,91], 0), convind(358390)))

%% A 1D size returns the index unchanged
assert(isequal(convind(3, [1,5]), 3))
assert(isequal(convind(3, [5,1]), 3))

%% Error if the coordinate vector has the wrong length
errored = 0;
try
    convind([1,2], [91,109,91]);
catch
    errored = 1;
end
assert(errored == 1)
