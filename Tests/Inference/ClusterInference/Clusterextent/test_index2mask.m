%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the index2mask function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2D
indices = [100, 2000, 50000];
mask = index2mask(indices);
% This will create a 3D mask of size [91, 109, 91] with the positions
% corresponding to the linear indices 100, 2000, and 50000 set to 1.
