%% test_srf_colour
% Tests of the srf_colour function
%--------------------------------------------------------------------------
m1 = logical([1 1 0 0 0]');
m2 = logical([0 1 1 0 0]');
yellow = [1, 1, 0];
red = [1, 0, 0];

%% Colours and the default background
cmap = srf_colour([], {m1, m2}, {yellow, red});
assert(isequal(size(cmap), [5, 3]))
assert(isequal(cmap(1,:), yellow))
assert(isequal(cmap(2,:), red))      % later masks are on top
assert(isequal(cmap(3,:), red))
assert(isequal(cmap(4:5,:), 0.7*ones(2,3)))

%% Background gradient
cmap = srf_colour([], {m1}, {yellow}, 0.2);
assert(isequal(cmap(3:5,:), 0.2*ones(3,3)))
assert(isequal(cmap(1:2,:), [yellow; yellow]))

%% Masks that are not logical
cmap = srf_colour([], {double(m1)}, {red});
assert(isequal(cmap(1:2,:), [red; red]))
assert(isequal(cmap(3,:), 0.7*ones(1,3)))

%% On a surface
rng(1)
srf = loadsrf('fs3', 'white');
noise = srf_noise(srf, 10, 1);
cmap = srf_colour(srf.lh, {noise.lh > 0}, {yellow});
assert(isequal(size(cmap), [srf.lh.nvertices, 3]))
assert(all(all(cmap(noise.lh > 0, :) == yellow)))
assert(all(all(cmap(noise.lh <= 0, :) == 0.7)))

%% Both hemispheres
clear mk
mk.lh = noise.lh > 0;
mk.rh = noise.rh > 0;
cmap = srf_colour(srf, {mk}, {red});
assert(isfield(cmap, 'lh') && isfield(cmap, 'rh'))
assert(isequal(cmap.lh, srf_colour(srf.lh, {mk.lh}, {red})))
assert(isequal(cmap.rh, srf_colour(srf.rh, {mk.rh}, {red})))

%% Both hemispheres use the background gradient
cmap = srf_colour(srf, {mk}, {red}, 0.3);
assert(all(all(cmap.lh(~mk.lh, :) == 0.3)))
assert(all(all(cmap.rh(~mk.rh, :) == 0.3)))

disp('test_srf_colour: all tests passed')
