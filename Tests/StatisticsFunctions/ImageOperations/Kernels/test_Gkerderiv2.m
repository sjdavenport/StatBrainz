%% test_Gkerderiv2
% Tests for Gkerderiv2: second derivative of the 1D Gaussian kernel.
%--------------------------------------------------------------------------
tol = 1e-12;

%% Equals the third output of Gker
x = [-2, -0.5, 0, 0.5, 3];
[~, ~, deriv2] = Gker( x, 3 );
assert( max( abs( Gkerderiv2( x, 3 ) - deriv2 ) ) < tol )

%% At 0 it is -1/sigma2 times the kernel maximum
sigma2 = FWHM2sigma(3)^2;
assert( abs( Gkerderiv2( 0, 3 ) + 1/sigma2/sqrt(2*pi*sigma2) ) < tol )

%% Zero at +-sigma and even
assert( max( abs( Gkerderiv2( [-1 1]*sqrt(sigma2), 3 ) ) ) < tol )
assert( max( abs( Gkerderiv2( x, 3 ) - Gkerderiv2( -x, 3 ) ) ) < tol )

%% Matches a finite difference of Gkerderiv
h = 1e-6;
assert( abs( Gkerderiv2( 0.8, 3 ) - ( Gkerderiv( 0.8+h, 3 ) - Gkerderiv( 0.8-h, 3 ) )/(2*h) ) < 1e-8 )

%% Output has the size of x
assert( isequal( size( Gkerderiv2( ones(3,2), 3 ) ), [3 2] ) )
