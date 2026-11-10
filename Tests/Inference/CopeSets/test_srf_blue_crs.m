% Tests for srf_blue_crs

srf = loadsrf('fs4', 'white');
nv = srf.lh.nvertices;
% Three groups: confidently below -c, maybe below -c, above -c
grp = mod((1:nv)', 3);
lower_band = zeros(nv, 1); upper_band = zeros(nv, 1);
lower_band(grp == 0) = -2; upper_band(grp == 0) = -1;  % upper set (below)
lower_band(grp == 1) = -1; upper_band(grp == 1) = 1;   % lower set only
lower_band(grp == 2) = 1;  upper_band(grp == 2) = 2;   % neither
xbar = 5*ones(nv, 1);  % -xbar is below c, so no contour
c = 0;

%% Size and range of the colour map
color_map = srf_blue_crs(srf.lh, lower_band, upper_band, xbar, c);
assert(isequal(size(color_map), [nv, 3]))
assert(all(color_map(:) >= 0 & color_map(:) <= 1))

%% Colours: dark blue for the upper set, light blue for the lower set
assert(all(ismember(color_map(grp == 0, :), [0, 0, 0.9], 'rows')))
assert(all(ismember(color_map(grp == 1, :), [0.5, 0.5, 1], 'rows')))
assert(all(ismember(color_map(grp == 2, :), [0.7, 0.7, 0.7], 'rows')))

%% The contour of the negative excursion set is cyan
xbar2 = -((grp == 1) + 0);
contour = srf_contour(srf.lh, -xbar2 > 0.5) > 0;
color_map = srf_blue_crs(srf.lh, lower_band, upper_band, xbar2, 0.5);
assert(all(ismember(color_map(contour, :), [0, 1, 1], 'rows')))
