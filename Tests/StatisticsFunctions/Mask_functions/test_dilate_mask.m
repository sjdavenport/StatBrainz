%% test_dilate_mask
% Tests for dilate_mask: dilation (positive) or erosion (negative).
%--------------------------------------------------------------------------

%% Default dilation is 1 voxel with a box element
mask = zeros(7); mask(4,4) = 1;
expected = false(7); expected(3:5, 3:5) = true;
out = dilate_mask( mask );
assert( islogical(out) && isequal( out, expected ) )
assert( isequal( dilate_mask( mask, 1 ), box_dilate( mask, 1 ) ) )

%% Dilation by 2
expected = false(7); expected(2:6, 2:6) = true;
assert( isequal( dilate_mask( mask, 2 ), expected ) )

%% Erosion of a 5 x 5 block by 1 gives a 3 x 3 block
mask = zeros(9); mask(3:7, 3:7) = 1;
expected = false(9); expected(4:6, 4:6) = true;
assert( isequal( dilate_mask( mask, -1 ), expected ) )

%% Erosion removes thin lines
mask = zeros(7); mask(4, :) = 1;
assert( ~any( dilate_mask( mask, -1 ), 'all' ) )

%% Erosion treats outside the image as foreground
mask = ones(4);
assert( all( dilate_mask( mask, -1 ), 'all' ) )

%% dilation 0 returns the mask as logical
mask = [0 1; 1 0];
assert( isequal( dilate_mask( mask, 0 ), logical(mask) ) )

%% Dilate then erode a block gives back the block
mask = zeros(10, 10, 10); mask(3:6, 4:8, 3:5) = 1;
assert( isequal( dilate_mask( dilate_mask( mask, 1 ), -1 ), logical(mask) ) )
