%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the voxLCE function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rng(0)
tfce_tstat = randn(20, 20).^2 * 3;
tfce_threshold = 5;
H = 2;    % height exponent (no default in source)
h0 = 0;   % cluster forming threshold (no default in source)
voxel_significant_im = voxLCE(tfce_tstat, tfce_threshold, H, h0);
sum(voxel_significant_im(:))
