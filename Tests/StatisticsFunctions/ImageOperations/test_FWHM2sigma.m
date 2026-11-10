%% test_FWHM2sigma
% Tests for FWHM2sigma: FWHM = sigma*sqrt(8*log(2)).
%--------------------------------------------------------------------------
tol = 1e-12;

%% Known value
assert( abs( FWHM2sigma( sqrt(8*log(2)) ) - 1 ) < tol )
assert( abs( FWHM2sigma( 5 ) - 2.1233045007 ) < 1e-9 )

%% Vector input is converted elementwise
assert( max( abs( FWHM2sigma( [0 1 2] ) - [0 1 2]/sqrt(8*log(2)) ) ) < tol )

%% The kernel at sigma = FWHM2sigma(FWHM) is half its maximum at FWHM/2
FWHM = 7; sigma = FWHM2sigma(FWHM);
assert( abs( exp( -(FWHM/2)^2/(2*sigma^2) ) - 0.5 ) < tol )

%% Round trip with sigma2FWHM
assert( abs( sigma2FWHM( FWHM2sigma( 3.3 ) ) - 3.3 ) < tol )
