%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srfplot2 function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% See test_srfplot.m
% TODO: example inputs are placeholders — verify against intended usage.
srf = loadsrf('fs5', 'white');
noise = srf_noise( srf, 10, 1 );
srfplot2(srf.lh, noise.lh)
exportgraphics(gcf, [statbrainz_maindir, 'tests/Figures/srfplot2.png'])
