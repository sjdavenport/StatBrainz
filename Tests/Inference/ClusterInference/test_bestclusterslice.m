%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the bestclusterslice function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)

%% Total in each slice and the slice with the largest total
im = zeros(5,6,7);
im(2:3, 2:4, 3) = 1;      % 6 voxels in z-slice 3
im(2, 2, 4:5) = 1;        % 1 voxel in each of z-slices 4 and 5
[maxsumlocs, totalinslice] = bestclusterslice( 3, im );
assert( isequal( totalinslice, [0,0,6,1,1,0,0] ) )
assert( isequal( maxsumlocs, 3 ) )

%% Other dimensions
[maxx, totx] = bestclusterslice( 1, im );
assert( isequal( totx, [0,5,3,0,0] ) )
assert( isequal( maxx, 2 ) )
[maxy, toty] = bestclusterslice( 2, im );
assert( isequal( toty, [0,4,2,2,0,0] ) )
assert( isequal( maxy, 2 ) )

%% Ties return all the maximal slices
im2 = zeros(4,4,4);
im2(1,1,2) = 1; im2(1,1,4) = 1;
maxsumlocs = bestclusterslice( 3, im2 );
assert( isequal( maxsumlocs, [2,4] ) )

%% slice_no = 0 gives the best slice in each dimension
maxsumlocs = bestclusterslice( 0, im );
assert( isequal( maxsumlocs, [2,2,3] ) )

%% A vector of linear indices is converted with index2mask (MNI size)
mask = zeros(91,109,91);
mask(40:42, 50, 30) = 1;
[maxsumlocs, totalinslice] = bestclusterslice( 1, find(mask) );
assert( isequal( size(totalinslice), [1,91] ) )
assert( isequal( maxsumlocs, [40,41,42] ) )
assert( sum(totalinslice) == 3 )

%% Cell array input gives one output per cluster
% The help says that surviving_cluster_im can be a cell array.
clusters = { find(mask), sub2ind([91,109,91], 10, 10, 10) };
try
    [maxsumlocs, totalinslice] = bestclusterslice( 3, clusters );
    ok = iscell(maxsumlocs) && numel(maxsumlocs) == 2 ...
         && isequal( maxsumlocs{1}, 30 ) && isequal( maxsumlocs{2}, 10 );
catch
    ok = 0;
end
assert( ok == 1, 'bestclusterslice fails for a cell array input' )
