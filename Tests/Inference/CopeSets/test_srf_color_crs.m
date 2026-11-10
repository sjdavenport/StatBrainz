% Tests for srf_color_crs

srf = loadsrf('fs4', 'white');
nv = srf.lh.nvertices;
% Three groups of vertices: confidently above c, maybe above c, below c
grp = mod((1:nv)', 3);
lower_band = zeros(nv, 1); upper_band = zeros(nv, 1);
lower_band(grp == 0) = 1;  upper_band(grp == 0) = 2;   % upper set
lower_band(grp == 1) = -1; upper_band(grp == 1) = 1;   % lower set only
lower_band(grp == 2) = -2; upper_band(grp == 2) = -1;  % neither
xbar = -5*ones(nv, 1);  % no excursion set, so no contour
c = 0;

%% Size and range of the colour map
color_map = srf_color_crs(srf.lh, lower_band, upper_band, xbar, c);
assert(isequal(size(color_map), [nv, 3]))
assert(all(color_map(:) >= 0 & color_map(:) <= 1))

%% Default bowring colours: upper red, lower blue, background grey
assert(all(ismember(color_map(grp == 0, :), [1, 0, 0], 'rows')))
assert(all(ismember(color_map(grp == 1, :), [0, 0, 1], 'rows')))
assert(all(ismember(color_map(grp == 2, :), [0.7, 0.7, 0.7], 'rows')))

%% The contour of the excursion set is yellow
xbar2 = (grp == 0) + 0;
color_map = srf_color_crs(srf.lh, lower_band, upper_band, xbar2, 0.5, 1, 'bowring', 0);
% with usecontour = 0 the yellow set is drawn under the upper set
assert(all(ismember(color_map(grp == 0, :), [1, 0, 0], 'rows')))
contour = srf_contour(srf.lh, xbar2 > 0.5) > 0;
color_map = srf_color_crs(srf.lh, lower_band - 3, upper_band - 3, xbar2, 0.5);
assert(all(ismember(color_map(contour, :), [1, 1, 0], 'rows')))

%% Negative direction: confidently below -c is the upper set
color_map = srf_color_crs(srf.lh, -upper_band, -lower_band, xbar, c, -1);
assert(all(ismember(color_map(grp == 0, :), [1, 0, 0], 'rows')))
assert(all(ismember(color_map(grp == 2, :), [0.7, 0.7, 0.7], 'rows')))

%% The blue and red schemes are different
color_blue = srf_color_crs(srf.lh, lower_band, upper_band, xbar, c, 1, 'blue');
color_red = srf_color_crs(srf.lh, lower_band, upper_band, xbar, c, 1, 'red');
assert(all(ismember(color_blue(grp == 0, :), [0, 0, 0.9], 'rows')))
assert(~isequal(color_blue, color_red))
