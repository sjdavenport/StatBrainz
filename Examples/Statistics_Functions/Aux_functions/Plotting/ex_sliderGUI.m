%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the sliderGUI function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
f2plot = @(t) imagesc(sin(linspace(0,2*pi,50)'*t));
sliderGUI(f2plot, 0.5, 5, 'frequency')
exportgraphics(gcf, [statbrainz_maindir, 'Examples/Figures/sliderGUI.png'])
