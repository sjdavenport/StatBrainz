%% test_BigFont
% Smoke tests of the BigFont function.
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')

%% Runs with the default size and returns the figure children
figure; plot(1:10, rand(1, 10)); title('BigFont')
h = BigFont;
assert(isequal(h, get(gcf, 'Children')))
close all

%% Runs with a given size
figure; plot(1:10)
h = BigFont(30);
assert(~isempty(h))
close all

%% Runs with no output
figure; plot(1:10)
BigFont(12)
close all
