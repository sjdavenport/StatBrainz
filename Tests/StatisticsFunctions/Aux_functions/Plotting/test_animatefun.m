%% test_animatefun
% Smoke tests of the animatefun function.
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')

%% Runs over a range of values with the default pause
fun = @(t) plot(1:10, sin((1:10)*t));
animatefun(fun, 0.5, 1, 0.25)
close all

%% Runs with a given pause
animatefun(fun, 0, 1, 0.5, 0)
close all

%% A function that errors makes animatefun error
errored = 0;
try
    animatefun(@(t) error('stop'), 0, 1, 0.5, 0)
catch
    errored = 1;
end
assert(errored == 1)
close all
