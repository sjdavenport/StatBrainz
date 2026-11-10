%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the index2mask function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)

%% Default dim is the MNI size [91,109,91]
mask = index2mask( [100, 2000, 50000] );
assert( isequal( size(mask), [91,109,91] ) )
assert( nnz(mask) == 3 )
assert( isequal( find(mask)', [100, 2000, 50000] ) )

%% 2D dim
mask = index2mask( [1; 6; 12], [3,4] );
expected = zeros(3,4); expected([1,6,12]) = 1;
assert( isequal( mask, expected ) )

%% Inverse of find
im = rand(5,6,7) > 0.7;
assert( isequal( index2mask( find(im), size(im) ), double(im) ) )

%% Repeated and empty indices
assert( nnz( index2mask( [2, 2, 3], [4,4] ) ) == 2 )
assert( isequal( index2mask( [], [2,3] ), zeros(2,3) ) )

%% Error for an index outside the array
try
    index2mask( 13, [3,4] );
    errored = 0;
catch
    errored = 1;
end
assert( errored == 1 )
