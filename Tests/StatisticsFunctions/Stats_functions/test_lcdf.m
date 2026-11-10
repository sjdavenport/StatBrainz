%% test_lcdf
% Tests for lcdf: CDF of the Laplace distribution.
%--------------------------------------------------------------------------
tol = 1e-12;

%% Known values
assert( abs( lcdf( 0, 0, 1 ) - 0.5 ) < tol )
assert( abs( lcdf( 1, 0, 1 ) - ( 1 - 0.5*exp(-1) ) ) < tol )
assert( abs( lcdf( -1, 0, 1 ) - 0.5*exp(-1) ) < tol )
assert( abs( lcdf( 5, 3, 2 ) - ( 1 - 0.5*exp(-1) ) ) < tol )

%% Symmetry about mu
t = [0.1 1 3];
assert( max( abs( lcdf( 2 + t, 2, 0.5 ) + lcdf( 2 - t, 2, 0.5 ) - 1 ) ) < tol )

%% Matches the empirical CDF of Laplace noise from wnoise
rng(0); a = wnoise( [1 1e5], 1, 'L', 1.5 );
assert( abs( mean( a(:) <= 1 ) - lcdf( 1, 0, 1.5 ) ) < 0.01 )

%% Output has the size of x and is increasing
x = reshape( -3:0.5:2.5, 3, 4 );
F = lcdf( x, 0, 1 );
assert( isequal( size(F), [3 4] ) && all( diff( F(:) ) > 0 ) )

%% Non-positive scale gives an error
for b = [0 -1]
    err = 0;
    try
        lcdf( 1, 0, b );
    catch
        err = 1;
    end
    assert( err == 1 )
end
