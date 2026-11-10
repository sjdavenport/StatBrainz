%% test_GkerMV2
% Tests for GkerMV2: multivariate Gaussian kernel with a FWHM (or variance)
% in each dimension.
%--------------------------------------------------------------------------
tol = 1e-12;

%% 2D anisotropic kernel is the product of 1D kernels
assert( abs( GkerMV2( [1; 2], [2; 5] ) - Gker( 1, 2 )*Gker( 2, 5 ) ) < tol )

%% Each column is a separate point
x = [0, 1, 2; 0, 0, 1];
val = GkerMV2( x, [2; 5] );
assert( isequal( size(val), [1 3] ) )
for I = 1:3
    assert( abs( val(I) - Gker( x(1,I), 2 )*Gker( x(2,I), 5 ) ) < tol )
end

%% Isotropic FWHM equals GkerMV
assert( abs( GkerMV2( [1; 2], [3; 3] ) - GkerMV( [1; 2], 3 ) ) < tol )

%% Variance parametrisation
assert( abs( GkerMV2( [1; 2], [1; 4], 0 ) - Gker( 1, 1, 0 )*Gker( 2, 4, 0 ) ) < tol )
assert( abs( GkerMV2( [0; 0], [1; 4], 0 ) - 1/(2*pi*2) ) < tol )

%% D = 3 is the product of 1D kernels
val = GkerMV2( [1; 1; 1], [2; 3; 4] );
assert( abs( val - Gker( 1, 2 )*Gker( 1, 3 )*Gker( 1, 4 ) ) < tol )
