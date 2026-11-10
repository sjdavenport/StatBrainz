%% test_zero2nan
% Tests for zero2nan: zeros (|x| <= 2*eps) become NaN.
%--------------------------------------------------------------------------

%% Zeros become NaN, other values are kept
out = zero2nan( [1, 5.1, 0, 0, 0.0001] );
assert( isequal( isnan(out), logical([0 0 1 1 0]) ) )
assert( isequal( out(~isnan(out)), [1, 5.1, 0.0001] ) )

%% Values within 2*eps of zero count as zero
out = zero2nan( [eps, -eps, 3*eps, 1e-20] );
assert( isequal( isnan(out), logical([1 1 0 1]) ) )

%% Logical input gives a double with NaN
out = zero2nan( logical([1 0; 0 1]) );
assert( isa( out, 'double' ) && isequal( out(1,1), 1 ) && isnan( out(1,2) ) )

%% Size is kept and an array without zeros is unchanged
x = reshape( 1:24, 2, 3, 4 );
assert( isequal( zero2nan(x), x ) )
