%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srf_color_crs function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

srf = loadsrf('fs4', 'white');
nv = srf.lh.nvertices;
lower_band = randn(nv, 1);
upper_band = lower_band + 0.5;
xbar = randn(nv, 1);
c = 0;
color_map = srf_color_crs(srf.lh, lower_band, upper_band, xbar, c);
size(color_map)
