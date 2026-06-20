%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the brainmove function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

brain = imgload('fullmean');
mask = imgload('MNImask')
[plane, clim] = brainmove(brain, [0,0,20], mask)
[plane, clim] = brainmove(brain, [0,0,20], mask, 10, 1, [0,1])
