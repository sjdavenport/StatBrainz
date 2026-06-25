%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srf_colour function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

srf = loadsrf('fs5', 'white')
noise = srf_noise( srf, 10, 1)
color_map = srf_colour( srf.lh, {noise.lh > 0, noise.lh < -0.1}, {[1,1,0], [1,0,0]} );
srfplot(srf.lh, color_map)
exportgraphics(gcf, [statbrainz_maindir, 'tests/Figures/srf_colour.png'])
