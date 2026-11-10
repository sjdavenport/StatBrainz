%% test_custom_colormap
% Tests of the custom_colormap function.
%--------------------------------------------------------------------------

%% Known values from black to white
cmap = custom_colormap([0, 0, 0], [1, 1, 1], 5);
assert(max(abs(cmap - repmat((0:4)'/4, 1, 3)), [], 'all') < 1e-12)

%% Default number of colours is 64
cmap = custom_colormap([1, 1, 0], [0.5, 0, 0.5]);
assert(isequal(size(cmap), [64, 3]))

%% End points are the two colours and each column is linear
color1 = [1, 1, 0]; color2 = [0.5, 0, 0.5];
cmap = custom_colormap(color1, color2, 11);
assert(isequal(size(cmap), [11, 3]))
assert(isequal(cmap(1, :), color1) && max(abs(cmap(end, :) - color2)) < 1e-12)
assert(max(abs(diff(cmap, 2)), [], 'all') < 1e-12)

%% Values stay in [0, 1] and the map can be used
assert(all(cmap(:) >= 0 & cmap(:) <= 1))
set(0, 'DefaultFigureVisible', 'off')
figure; imagesc(rand(5)); colormap(cmap); close all
