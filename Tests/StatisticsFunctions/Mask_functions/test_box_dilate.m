%% test_box_dilate
% Tests for box_dilate: dilation with a (2*radius+1) box, no toolbox.
%--------------------------------------------------------------------------

%% A single voxel becomes a 3 x 3 block
mask = zeros(5); mask(3,3) = 1;
expected = false(5); expected(2:4, 2:4) = true;
out = box_dilate( mask, 1 );
assert( islogical(out) && isequal( out, expected ) )

%% radius 0 returns a logical copy
mask = [0 2; 0 -1];
assert( isequal( box_dilate( mask, 0 ), logical(mask) ) )

%% Dilation is clipped at the border
mask = zeros(6); mask(1,6) = 1;
expected = false(6); expected(1:3, 4:6) = true;
assert( isequal( box_dilate( mask, 2 ), expected ) )

%% 3D single voxel becomes a 3 x 3 x 3 cube
mask = zeros(7,7,7); mask(4,4,4) = 1;
out = box_dilate( mask, 1 );
assert( sum(out(:)) == 27 && all( out(3:5,3:5,3:5), 'all' ) )

%% Matches a direct loop over every voxel
rng(0); mask = rand(12, 15) > 0.9; r = 2;
out = box_dilate( mask, r );
for i = 1:12
    for j = 1:15
        win = mask( max(i-r,1):min(i+r,12), max(j-r,1):min(j+r,15) );
        assert( out(i,j) == any( win(:) ) )
    end
end

%% A radius larger than the image fills everything
mask = zeros(4, 3); mask(2,2) = 1;
assert( all( box_dilate( mask, 10 ), 'all' ) )

%% Singleton dimensions are not a problem
mask = zeros(1, 9); mask(5) = 1;
assert( isequal( box_dilate( mask, 1 ), logical( [0 0 0 1 1 1 0 0 0] ) ) )
