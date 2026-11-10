%% test_squarescreen
% Tests of the squarescreen function (figures off).
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')

%% Sets the figure position
figure; imagesc(rand(5));
squarescreen;
assert(isequal(get(gcf, 'Position'), [0, 35, 650, 607]))
close all
