%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srf_fwhm2niters function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

srf = loadsrf('fs5', 'sphere')
% srf_fwhm2niters expects a single-hemisphere struct (with .nvertices), so
% pass srf.lh rather than the lh/rh container returned by loadsrf.
niters = srf_fwhm2niters( 8, srf.lh )
