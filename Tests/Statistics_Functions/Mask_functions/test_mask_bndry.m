%% test_mask_bndry
% Tests for mask_bndry: outer and inner boundaries of a mask.
%--------------------------------------------------------------------------

%% 3 x 3 block: outer ring of 16 voxels, inner ring of 8 voxels
mask = zeros(7); mask(3:5, 3:5) = 1;
[outer, inner] = mask_bndry( mask );
expected_outer = zeros(7); expected_outer(2:6, 2:6) = 1; expected_outer(3:5, 3:5) = 0;
expected_inner = mask; expected_inner(4,4) = 0;
assert( isequal( outer, expected_outer ) && isequal( inner, expected_inner ) )

%% Boundaries do not overlap the mask / the complement
assert( ~any( outer(:) & mask(:) ) && all( mask( inner == 1 ) == 1 ) )

%% nonboundary_mask removes voxels from both boundaries
nonbndry = zeros(7); nonbndry(:, 1:3) = 1;
[outer2, inner2] = mask_bndry( mask, nonbndry );
assert( isequal( outer2, expected_outer.*(1 - nonbndry) ) )
assert( isequal( inner2, expected_inner.*(1 - nonbndry) ) )
assert( sum(outer2(:)) == 9 && sum(inner2(:)) == 5 )

%% 3D cube: inner boundary is the cube minus its interior
mask = zeros(8, 8, 8); mask(2:6, 2:6, 2:6) = 1;
[outer, inner] = mask_bndry( mask );
assert( sum(inner(:)) == 5^3 - 3^3 )
assert( sum(outer(:)) == 7^3 - 5^3 )
