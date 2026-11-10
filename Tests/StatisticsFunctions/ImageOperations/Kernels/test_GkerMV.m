%% test_GkerMV
% Tests for GkerMV: isotropic multivariate Gaussian kernel.
%--------------------------------------------------------------------------
tol = 1e-12;

%% D = 1 equals Gker
assert( abs( GkerMV( 0.7, 3 ) - Gker( 0.7, 3 ) ) < tol )

%% D = 2 is the product of 1D kernels
assert( abs( GkerMV( [1; 2], 3 ) - Gker( 1, 3 )*Gker( 2, 3 ) ) < tol )

%% D = 3 is the product of 1D kernels
assert( abs( GkerMV( [1; -2; 0.5], 4 ) - Gker( 1, 4 )*Gker( -2, 4 )*Gker( 0.5, 4 ) ) < tol )

%% Each column is a separate point
x = [1, 3; 2, 4];
val = GkerMV( x, 3 );
assert( isequal( size(val), [1 2] ) )
assert( abs( val(2) - GkerMV( [3; 4], 3 ) ) < tol )

%% Variance parametrisation: value at 0 is (2*pi*sigma2)^(-D/2)
assert( abs( GkerMV( [0; 0], 4, 0 ) - 1/(2*pi*4) ) < tol )
assert( abs( GkerMV( [1; 1], 3 ) - GkerMV( [1; 1], FWHM2sigma(3)^2, 0 ) ) < tol )

%% 2D kernel integrates to 1
[a, b] = ndgrid( -20:0.1:20 );
v = GkerMV( [a(:)'; b(:)'], 4 );
assert( abs( sum(v)*0.01 - 1 ) < 1e-8 )
