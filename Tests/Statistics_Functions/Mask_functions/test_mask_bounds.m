%% test_mask_bounds
% Tests for mask_bounds: the bounding box of a mask.
%--------------------------------------------------------------------------

%% 2D bounds and bounded mask
mask = zeros(10, 12); mask(3:5, 4:9) = 1; mask(4, 6) = 0;
[bounds, bounded] = mask_bounds( mask );
assert( isequal( bounds, {3:5, 4:9} ) )
assert( islogical(bounded) && isequal( bounded, logical( mask(3:5, 4:9) ) ) )

%% Default padding is 0
assert( isequal( mask_bounds( mask, 0 ), bounds ) )

%% Padding adds voxels and is clipped at the edges
assert( isequal( mask_bounds( mask, 1 ), {2:6, 3:10} ) )
assert( isequal( mask_bounds( mask, 5 ), {1:10, 1:12} ) )

%% A padding for each dimension
assert( isequal( mask_bounds( mask, [0 2] ), {3:5, 2:11} ) )

%% 3D with separate voxels
mask = zeros(6, 7, 8); mask(2, 3, 4) = 1; mask(5, 6, 7) = 1;
[bounds, bounded] = mask_bounds( mask );
assert( isequal( bounds, {2:5, 3:6, 4:7} ) )
assert( isequal( size(bounded), [4 4 4] ) && sum(bounded(:)) == 2 )
