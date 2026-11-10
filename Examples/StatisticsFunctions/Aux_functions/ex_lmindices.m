%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the lmindices function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1D examples
lmindices([1,3,1])
lmindices([1,2,1,2,1], 2)

% Exclude the boundary with a mask
lmindices([1,2,3], 1, [1,1,0])

%% 2D example
[ lmarrayindices, lmind ] = lmindices([1,1,1;1,2,1;1,1,1])

%% 3D example: the top 2 peaks of an image in MNI space
a = zeros([91,109,91]);
a(16,100,40) = 5;
a(10,50,35) = 3;
[ peaklocs, peakinds, peakvals ] = lmindices(a, 2)
isequal(a(peakinds), peakvals)
