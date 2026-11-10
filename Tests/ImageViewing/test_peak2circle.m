%% test_peak2circle
% Tests of the peak2circle function.
%--------------------------------------------------------------------------
point = [49, 50, 49];
circlemask = peak2circle( point );

%% Output is a logical array in 1mm MNI space
assert(isequal(size(circlemask), [182, 218, 182]))
assert(islogical(circlemask))

%% Shell is a 5x5x5 cube with the 3x3x3 centre removed
assert(nnz(circlemask) == 5^3 - 3^3)
c = 2*point;
cube = circlemask(c(1)-2:c(1)+2, c(2)-2:c(2)+2, c(3)-2:c(3)+2);
assert(all(cube([1,5],:,:), 'all') && all(cube(:,[1,5],:), 'all') && all(cube(:,:,[1,5]), 'all'))
assert(~any(cube(2:4, 2:4, 2:4), 'all'))

%% The centre voxel is not in the shell
assert(~circlemask(c(1), c(2), c(3)))

%% Agrees with a shell built from the distance to the centre
point = [30, 40, 70];
c = 2*point;
[X, Y, Z] = ndgrid(1:182, 1:218, 1:182);
cheb = max(max(abs(X - c(1)), abs(Y - c(2))), abs(Z - c(3)));
assert(isequal(peak2circle( point ), cheb == 2))
