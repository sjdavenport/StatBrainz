%% test_add_region
% Tests of the add_region function (smoke tests, figures off).
%--------------------------------------------------------------------------
rng(1)
set(0, 'DefaultFigureVisible', 'off')
[noise, ss] = fast_conv(randn([30,30]), 3, 2);
noise = noise./sqrt(ss);
mask1 = noise > 1;
mask2 = noise > 1.5;

%% Two regions with two colours
figure; imagesc(noise); add_region( {mask1, mask2}, {'blue', 'red'} );

%% A single mask (not in a cell) with the default colour
figure; imagesc(noise); add_region( mask1 );

%% One colour for several regions, RGB colour and transparency
figure; imagesc(noise); add_region( {mask1, mask2}, 'green', 0.5 );
figure; imagesc(noise); add_region( {mask1}, {[0.2, 0.4, 0.6]} );

%% A different number of colours and regions gives an error
errored = 0;
try
    add_region( {mask1, mask2}, {'blue', 'red', 'green'} );
catch
    errored = 1;
end
assert(errored == 1)
close all
