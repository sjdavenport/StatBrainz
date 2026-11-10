% Tests for srf_redblue_crs

srf = loadsrf('fs4', 'white');
nv = srf.lh.nvertices;
% Four groups: confidently above c, confidently below -c, maybe both, neither
grp = mod((1:nv)', 4);
lower_band = zeros(nv, 1); upper_band = zeros(nv, 1);
lower_band(grp == 0) = 1;    upper_band(grp == 0) = 2;     % above c
lower_band(grp == 1) = -2;   upper_band(grp == 1) = -1;    % below -c
lower_band(grp == 2) = -1;   upper_band(grp == 2) = 1;     % in both lower sets
lower_band(grp == 3) = -0.1; upper_band(grp == 3) = 0.1;   % in no set (c = 0.5)
xbar = (lower_band + upper_band)/2;
c = 0.5;

%% Size and range of the colour map
color_map = srf_redblue_crs(srf.lh, lower_band, upper_band, xbar, c);
assert(isequal(size(color_map), [nv, 3]))
assert(all(color_map(:) >= 0 & color_map(:) <= 1))

%% Colours with the lower sets (default)
assert(all(ismember(color_map(grp == 0, :), [0.9, 0, 0], 'rows')))
assert(all(ismember(color_map(grp == 1, :), [0, 0, 0.9], 'rows')))
assert(all(ismember(color_map(grp == 2, :), [0.5765, 0.4392, 0.6], 'rows')))
assert(all(ismember(color_map(grp == 3, :), [0.7, 0.7, 0.7], 'rows')))

%% Without the lower sets only the upper sets are coloured
color_map = srf_redblue_crs(srf.lh, lower_band, upper_band, xbar, c, 0);
assert(all(ismember(color_map(grp == 0, :), [0.9, 0, 0], 'rows')))
assert(all(ismember(color_map(grp == 1, :), [0, 0, 0.9], 'rows')))
assert(all(ismember(color_map(grp == 2, :), [0.7, 0.7, 0.7], 'rows')))
