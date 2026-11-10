%% test_fill_holes
% Tests for fill_holes: fills background not connected to the border
% (4-connected), like imfill( BW, 'holes' ).
%--------------------------------------------------------------------------

%% A square with a hole becomes a full square
BW = zeros(7); BW(2:6, 2:6) = 1; BW(4,4) = 0;
expected = false(7); expected(2:6, 2:6) = true;
out = fill_holes( BW );
assert( islogical(out) && isequal( out, expected ) )

%% A ring becomes a disc
R = MkRadImg( [30, 30], [15.5, 15.5] );
assert( isequal( fill_holes( R <= 10 & R >= 7 ), R <= 10 ) )

%% Background that touches the border is not filled
BW = zeros(6); BW(2:5, 2:5) = 1; BW(3:4, 3:6) = 0;
assert( isequal( fill_holes( BW ), logical(BW) ) )

%% Diagonal contact with outside is not a connection (4-connectivity)
BW = ones(5); BW(1,1) = 0; BW(2,2) = 0;
expected = true(5); expected(1,1) = false;
assert( isequal( fill_holes( BW ), expected ) )

%% Empty and full images are unchanged
assert( isequal( fill_holes( zeros(4, 6) ), false(4, 6) ) )
assert( isequal( fill_holes( ones(3) ), true(3) ) )

%% Several holes are all filled
BW = ones(9, 11); BW(3, 3) = 0; BW(5:6, 7:9) = 0;
assert( all( fill_holes( BW ), 'all' ) )
