%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the srfplot2 function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% See ex_srfplot.m
% TODO: example inputs are placeholders — verify against intended usage.
srf = loadsrf('fs5', 'white');
noise = srf_noise( srf, 10, 1 );
srfplot2(srf.lh, noise.lh)
figpath = [statbrainz_maindir, 'Examples/Figures/srfplot2.png'];
exportgraphics(gcf, figpath)
fprintf('srfplot2: figure written, file exists: %d\n', isfile(figpath));
