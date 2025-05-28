%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srf_noise function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generate smooth noise
srf = loadsrf('fs5', 'white');

FWHM = 10;
nsubj = 5;

noise = srf_noise( srf, FWHM, nsubj, 'ones' );

srfplot(srf.lh, noise.lh(:,1))

%% Generate smooth noise with a mask!
srf = loadsrf('fs5', 'white');

FWHM = 10;
nsubj = 5;

mask = loadmask( 'fs5', 'medial_wall' );
noise = srf_noise( srf, FWHM, nsubj, 'ones', mask);

%srfplot(srf.lh, noise.lh(:,1))