%% test_Gker
% Tests for Gker: 1D Gaussian kernel and its first two derivatives.
%--------------------------------------------------------------------------
tol = 1e-12;

%% Known values with variance parametrisation
assert( abs( Gker( 0, 1, 0 ) - 1/sqrt(2*pi) ) < tol )
assert( abs( Gker( 1, 1, 0 ) - exp(-1/2)/sqrt(2*pi) ) < tol )
assert( abs( Gker( 2, 4, 0 ) - exp(-1/2)/sqrt(8*pi) ) < tol )

%% Default is the FWHM parametrisation
FWHM = 3; sigma2 = FWHM2sigma(FWHM)^2;
assert( abs( Gker( 0.7, FWHM ) - Gker( 0.7, sigma2, 0 ) ) < tol )
assert( abs( Gker( 0.7, FWHM ) - Gker( 0.7, FWHM, 1 ) ) < tol )

%% Value at FWHM/2 is half the maximum
assert( abs( Gker( FWHM/2, FWHM )/Gker( 0, FWHM ) - 0.5 ) < tol )

%% Kernel integrates to 1
x = -30:0.01:30;
assert( abs( sum( Gker( x, 4 ) )*0.01 - 1 ) < 1e-8 )

%% Output has the size of x
assert( isequal( size( Gker( [1.5, 2; 0, 1], 3 ) ), [2 2] ) )
assert( isequal( size( Gker( [1.5, 2]', 3 ) ), [2 1] ) )

%% Derivatives match finite differences
x = [-2, -0.3, 0.4, 1.7]; h = 1e-5;
[val, deriv, deriv2] = Gker( x, FWHM );
[vp, dp] = Gker( x + h, FWHM ); [vm, dm] = Gker( x - h, FWHM );
assert( max( abs( deriv - (vp - vm)/(2*h) ) ) < 1e-8 )
assert( max( abs( deriv2 - (dp - dm)/(2*h) ) ) < 1e-8 )
assert( max( abs( val - Gker( x, sigma2, 0 ) ) ) < tol )
