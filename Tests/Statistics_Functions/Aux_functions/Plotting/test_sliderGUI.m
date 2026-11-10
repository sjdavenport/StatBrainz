%% test_sliderGUI
% Smoke tests of the sliderGUI function.
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')

%% Runs with a plotting function
f2plot = @(t) imagesc(sin(linspace(0, 2*pi, 20)'*t));
sliderGUI(f2plot, 0.5, 5, 'frequency')
close all

%% Runs with a negative range
sliderGUI(@(t) plot(1:10, t*(1:10)), -2, 2, 'slope')
close all

%% The function is called with the midpoint of the range
errored = 0;
try
    sliderGUI(@(t) assert(t == 1.5), 1, 2, 'x')
catch
    errored = 1;
end
assert(errored == 0)
close all
