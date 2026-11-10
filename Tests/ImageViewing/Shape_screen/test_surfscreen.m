%% test_surfscreen
% Tests of the surfscreen function (figures off).
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')

%% Sets the figure position
figure; imagesc(rand(5, 20));
surfscreen;
assert(isequal(get(gcf, 'Position'), [150, 1, 1200, 865]))
close all
