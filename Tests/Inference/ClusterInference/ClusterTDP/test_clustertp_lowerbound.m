%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the clustertp_lowerbound function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Known values computed by hand for cluster threshold k = 1, D = 3
% (rk = 7/8). CL+ is the set CL dilated by {0,1}^3.
%  - 1 voxel:  |CL+| = 8,  |CL+ \ CL| = 7:  7/8*8 - 7 = 0         -> 0
%  - 2 voxels: (|CL| > k) = 1, 7/8*12 - 10 = 0.5                    -> 1
%  - 2x2x2 cube: 7/8*27 - 19 = 4.625                                -> 5
rng(0)
mkCL = @(xyz) struct( 'x', xyz(:,1), 'y', xyz(:,2), 'z', xyz(:,3) );

%% Single voxel
assert( clustertp_lowerbound( mkCL([4,4,4]), 1, 3 ) == 0 )

%% Two neighbouring voxels
assert( clustertp_lowerbound( mkCL([4,4,4; 5,4,4]), 1, 3 ) == 1 )

%% 2x2x2 cube
[x, y, z] = ndgrid( 1:2, 1:2, 1:2 );
cube = [x(:), y(:), z(:)];
assert( clustertp_lowerbound( mkCL(cube), 1, 3 ) == 5 )

%% The bound does not depend on the position of the cluster
assert( clustertp_lowerbound( mkCL(cube + 10), 1, 3 ) == 5 )

%% Bounds on a larger cluster
[x, y, z] = ndgrid( 1:5, 1:4, 1:3 );
block = [x(:), y(:), z(:)];
nvox = size(block, 1);
for k = [1, 5, 20, 59, 60]
    lb = clustertp_lowerbound( mkCL(block), k, 3 );
    assert( lb == round(lb) )
    assert( lb >= (nvox > k) && lb <= nvox )
end
% A larger threshold cannot give a larger bound
lbs = arrayfun( @(k) clustertp_lowerbound( mkCL(block), k, 3 ), [1, 5, 20, 40] );
assert( all( diff(lbs) <= 0 ) )

%% A cluster that is not larger than the threshold
assert( clustertp_lowerbound( mkCL(block), nvox, 3 ) == 0 )

%% Integer typed coordinates
assert( clustertp_lowerbound( mkCL(int16(cube)), 1, 3 ) == 5 )
