%% test_slidergui3
% Smoke tests of the slidergui3 function.
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')

%% Runs with a plotting function of three values
f2plot = @(p) imagesc(sin(linspace(0, 2*pi, 20)'*p(1))*cos(linspace(0, 2*pi, 20)*p(2))*p(3));
slidergui3(f2plot, [0.5, 0.5, 0.5], [5, 5, 5], 'freq1', 'freq2', 'scale')
close all

%% The function is called with the midpoints of the ranges
errored = 0;
try
    slidergui3(@(p) assert(isequal(p, [1.5, 0, 10])), [1, -1, 0], [2, 1, 20], 'a', 'b', 'c')
catch
    errored = 1;
end
assert(errored == 0)
close all
