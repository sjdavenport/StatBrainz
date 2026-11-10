%% test_viewdata
% Tests of the viewdata function (smoke tests, figures off).
%--------------------------------------------------------------------------
rng(1)
set(0, 'DefaultFigureVisible', 'off')
data = randn(20, 25);
brain_mask = true(20, 25); brain_mask(1:3, :) = 0;
region = false(20, 25); region(5:10, 5:10) = 1;

%% Data and a brain mask only
figure; h = viewdata( data, brain_mask );
assert(~isempty(h))
if exist('isgraphics') > 0, assert(isgraphics(h)), end

%% With region masks, colours, rotation, bounds and alpha
figure; h = viewdata( data, brain_mask, {region, ~region}, {'red', 'blue'}, 2, {1:15, 1:20}, [1, 0.5], 1 );
assert(~isempty(h))
for rotate = 1:4
    figure; h = viewdata( data, brain_mask, region, 'green', rotate );
    assert(~isempty(h))
end

%% NaN values in the data
data(1:5, 1:5) = NaN;
figure; h = viewdata( data, brain_mask );
assert(~isempty(h))

%% A different number of colours and regions gives an error
errored = 0;
try
    viewdata( data, brain_mask, {region, region}, {'red', 'blue', 'green'} );
catch
    errored = 1;
end
assert(errored == 1)
close all
