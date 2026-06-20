%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the perm_thresh function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data = normrnd(0,1,20,1000);
[~, threshold] = perm_thresh(data, 'T');

%%
lat_data = wfield([5,5], 10);
tic; [~,threshold] = perm_thresh_new(lat_data, 'T'); toc
tic; [~,threshold] = perm_thresh(lat_data.field, 'T');toc

%%
% Normal data with 1 voxel (very similar (as expected)!)
nsubj = 100; data = randn(1,nsubj);
[~, thresh] = perm_thresh(data, 'Z')
1.96*std(data')/sqrt(nsubj)
