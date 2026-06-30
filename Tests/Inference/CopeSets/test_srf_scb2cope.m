%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srf_scb2cope function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

srf = loadsrf('fs4', 'white');
nv = srf.lh.nvertices;
lower_band_im = randn(nv, 1);
upper_band_im = lower_band_im + 0.5;
muhat = randn(nv, 1);
c = 0;
[lower_set, upper_set, contour, yellow_set] = srf_scb2cope(srf.lh, lower_band_im, upper_band_im, muhat, c);
[sum(lower_set), sum(upper_set), sum(contour), sum(yellow_set)]
