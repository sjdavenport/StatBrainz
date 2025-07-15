g = gifti('/Users/sdavenport/Documents/MyPapers/Other/Grant/gradients/HCPgrads/L.atlasroi.32k_fs_LR.shape.gii');
leftmask = logical(g.cdata);

g = gifti('/Users/sdavenport/Documents/MyPapers/Other/Grant/gradients/HCPgrads/R.atlasroi.32k_fs_LR.shape.gii');
rightmask = logical(g.cdata);

clear mask
mask.rh = rightmask;
mask.lh = leftmask;

save('/Users/sdavenport/Documents/Code/MATLAB/MyPackages/StatBrainz/BrainImages/Surface/hcp/hcp_mask.mat', 'mask')