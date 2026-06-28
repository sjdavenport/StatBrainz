%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the animatefun function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
fun = @(t) surf(sin(linspace(0,2*pi,50)'*t) * cos(linspace(0,2*pi,50)*t));
animatefun(fun, 0.5, 2, 0.5)
figpath = [statbrainz_maindir, 'tests/Figures/animatefun.png'];
exportgraphics(gcf, figpath)
fprintf('animatefun: figure written, file exists: %d\n', isfile(figpath));
