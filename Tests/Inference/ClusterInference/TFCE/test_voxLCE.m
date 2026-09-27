%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the voxLCE function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rng(0)
tstat = randn(20, 20).^2 * 3;
tfce_threshold = 5;
H = 2;
h0 = 0;
voxel_significant_im = voxLCE(tstat, tfce_threshold, H, h0);
sum(voxel_significant_im(:))
