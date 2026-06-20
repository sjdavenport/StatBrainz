%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the getregion function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
point = [50, 60, 40]; % coordinates in MNI space
getregion(point);

%% Second example point
point = [35,62,23];
getregion(point)

%% Using the derived atlas
point = round([35,62,23]*1.15);
getregion(point, '15')
