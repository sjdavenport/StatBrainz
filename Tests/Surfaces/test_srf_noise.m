%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srf_noise function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

srf = loadsrf('fs5', 'white');

FWHM = 10;
nsubj = 5;

noise = srf_noise( srf, FWHM, nsubj, 'ones' );

srfplot(srf.lh, noise.lh(:,1))