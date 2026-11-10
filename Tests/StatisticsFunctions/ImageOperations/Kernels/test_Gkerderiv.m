%% test_Gkerderiv
% Tests for Gkerderiv: first derivative of the 1D Gaussian kernel.
%--------------------------------------------------------------------------
tol = 1e-12;

%% Equals the second output of Gker
x = [-2, -0.5, 0, 0.5, 3];
[~, deriv] = Gker( x, 3 );
assert( max( abs( Gkerderiv( x, 3 ) - deriv ) ) < tol )

%% Known value: -x/sigma2 times the kernel
sigma2 = FWHM2sigma(4)^2;
assert( abs( Gkerderiv( 1, 4 ) - (-1/sigma2)*exp(-1/(2*sigma2))/sqrt(2*pi*sigma2) ) < tol )

%% Zero at 0 and odd
assert( Gkerderiv( 0, 3 ) == 0 )
assert( max( abs( Gkerderiv( x, 3 ) + Gkerderiv( -x, 3 ) ) ) < tol )

%% Matches a finite difference of GkerMV
h = 1e-6;
assert( abs( Gkerderiv( 1, 3 ) - ( GkerMV( 1+h, 3 ) - GkerMV( 1-h, 3 ) )/(2*h) ) < 1e-8 )

%% Output has the size of x
assert( isequal( size( Gkerderiv( ones(2,3), 3 ) ), [2 3] ) )
