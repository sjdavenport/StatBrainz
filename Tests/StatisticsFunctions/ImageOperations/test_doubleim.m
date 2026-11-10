%% test_doubleim
% Tests for doubleim: upsamples a 91 x 109 x 91 image by 2 (nearest
% neighbour) to 182 x 218 x 182.
%--------------------------------------------------------------------------
rng(0)
orig = rand(91, 109, 91);
new = doubleim( orig );

%% Output size
assert( isequal( size(new), [182, 218, 182] ) )

%% Each of the 8 sub-grids equals the original image
for I = 1:2, for J = 1:2, for K = 1:2
    assert( isequal( new(I:2:end, J:2:end, K:2:end), orig ) )
end, end, end

%% Each 2 x 2 x 2 block is constant and equals the original voxel
blk = new(2*10-1:2*10, 2*20-1:2*20, 2*30-1:2*30);
assert( all( blk(:) == orig(10, 20, 30) ) )

%% A binary mask stays binary with 8 times as many ones
mask = double( orig > 0.5 );
newmask = doubleim( mask );
assert( sum(newmask(:)) == 8*sum(mask(:)) )
