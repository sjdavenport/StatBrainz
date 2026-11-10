%% test_spherescreen
% Tests of the spherescreen function (figures off).
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')

%% Default: no colorbar
figure; surf(peaks(10));
spherescreen;
assert(max(abs(get(gcf, 'Position') - [360, 41.6667, 533.6667, 599.3333])) < 1e-3)

%% With a colorbar
figure; surf(peaks(10));
spherescreen(1);
assert(max(abs(get(gcf, 'Position') - [250, 41.6667, 600, 600])) < 1e-3)
close all
