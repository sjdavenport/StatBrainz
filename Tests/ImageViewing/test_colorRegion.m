%% test_colorRegion
% Tests of the colorRegion function.
%--------------------------------------------------------------------------
rng(1)
region_mask = rand(5, 6) > 0.5;
z = zeros(size(region_mask));
m = double(region_mask);

%% Output size
assert(isequal(size(colorRegion(region_mask, 'red')), [5, 6, 3]))

%% Named colours put the mask in the correct channels
assert(isequal(colorRegion(region_mask, 'red'), cat(3, m, z, z)))
assert(isequal(colorRegion(region_mask, 'green'), cat(3, z, m, z)))
assert(isequal(colorRegion(region_mask, 'blue'), cat(3, z, z, m)))
assert(isequal(colorRegion(region_mask, 'yellow'), cat(3, m, m, z)))
assert(isequal(colorRegion(region_mask, 'cyan'), cat(3, z, m, m)))
assert(isequal(colorRegion(region_mask, 'magenta'), cat(3, m, z, m)))
assert(isequal(colorRegion(region_mask, 'white'), cat(3, m, m, m)))
assert(isequal(colorRegion(region_mask, 'black'), cat(3, z, z, z)))
assert(isequal(colorRegion(region_mask, 'gray'), 0.5*cat(3, m, m, m)))
assert(isequal(colorRegion(region_mask, 'grey'), 0.5*cat(3, m, m, m)))

%% Unknown colour names and NaN give red
assert(isequal(colorRegion(region_mask, 'purple'), cat(3, m, z, z)))
assert(isequal(colorRegion(region_mask, NaN), cat(3, m, z, z)))

%% RGB vector input
rgb = [0.2, 0.4, 0.6];
assert(isequal(colorRegion(region_mask, rgb), cat(3, rgb(1)*m, rgb(2)*m, rgb(3)*m)))
