%% test_fullscreen2
% Tests of the fullscreen2 function (figures off).
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')

%% Resizes an existing figure to the screen size
figure; imagesc(rand(5));
screen_size = fullscreen2;
assert(isequal(screen_size, get(0, 'ScreenSize')))
assert(isequal(get(gcf, 'Position'), screen_size))

%% Makes a new figure when none is open
close all
screen_size = fullscreen2;
assert(~isempty(get(groot, 'CurrentFigure')))
assert(isequal(get(gcf, 'Position'), screen_size))
close all
