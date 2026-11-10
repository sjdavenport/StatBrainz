%% test_gmcdf
% Tests for gmcdf: CDF of a Gaussian mixture.
%--------------------------------------------------------------------------
tol = 1e-8;

%% One component equals normcdf
x = [-2 0 1.3];
assert( max( abs( gmcdf( x, 1, 1, 2 ) - normcdf( x, 1, 2 ) ) ) < 1e-12 )

%% Known values for a symmetric two component mixture
w = [0.5 0.5]; m = [-1 1]; s = [1 1];
assert( abs( gmcdf( 0, w, m, s ) - 0.5 ) < 1e-12 )
assert( abs( gmcdf( 1, w, m, s ) - ( 0.5*0.977249868 + 0.25 ) ) < tol )

%% CDF is increasing from 0 to 1
x = -50:0.5:50;
F = gmcdf( x, [0.2 0.3 0.5], [-3 0 4], [0.5 1 2] );
assert( all( diff(F) >= 0 ) )
assert( F(1) < 1e-10 && abs( F(end) - 1 ) < 1e-10 )

%% Output has the size of x
assert( isequal( size( gmcdf( zeros(2,3), w, m, s ) ), [2 3] ) )

%% Weights that do not sum to 1 or lengths that differ give errors
bad = { {0, [0.5 0.6], m, s}, {0, w, [1 2 3], s}, {0, w, m, 1} };
for I = 1:length(bad)
    err = 0;
    try
        gmcdf( bad{I}{:} );
    catch
        err = 1;
    end
    assert( err == 1 )
end
