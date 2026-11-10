%% test_fullscreen
% Tests of the fullscreen function (figures off).
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')

%% Returns the screen size
figure; imagesc(rand(5));
screen_size = fullscreen;
assert(isequal(screen_size, get(0, 'ScreenSize')))
assert(numel(screen_size) == 4)

%% Runs with no output
figure; fullscreen;
close all
