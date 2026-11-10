%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the getlargestcluster function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)

%% 2D: the largest cluster is kept
mask = zeros(10,10);
mask(2,2) = 1;
mask(5:8, 5:8) = 1;
clustermask = getlargestcluster( mask );
expected = zeros(10,10); expected(5:8, 5:8) = 1;
assert( isequal( size(clustermask), [10,10] ) )
assert( isequal( clustermask, expected ) )

%% 2D default connectivity is 8 (diagonal voxels join a cluster)
mask = zeros(8,8);
mask(1,1) = 1; mask(2,2) = 1; mask(3,3) = 1;   % 3 voxels on a diagonal
mask(6:7, 6) = 1;                              % 2 voxels
clustermask = getlargestcluster( mask );
assert( sum(clustermask(:)) == 3 )
assert( clustermask(2,2) == 1 && clustermask(6,6) == 0 )

%% 3D
mask = zeros(6,6,6);
mask(1:2,1:2,1:2) = 1;   % 8 voxels
mask(5,5,4:6) = 1;       % 3 voxels
clustermask = getlargestcluster( mask );
assert( isequal( size(clustermask), [6,6,6] ) )
assert( sum(clustermask(:)) == 8 )
assert( all( clustermask(mask(:) == 0) == 0 ) )

%% Logical input
mask = false(5,5); mask(1:3,1) = true; mask(5,5) = true;
clustermask = getlargestcluster( mask );
assert( sum(clustermask(:)) == 3 && clustermask(2,1) == 1 )
