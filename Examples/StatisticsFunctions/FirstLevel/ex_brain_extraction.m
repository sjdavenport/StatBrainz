%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the brain_extraction function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Extract a brain mask from the MNI T1 image with the default threshold
MNI = imgload('MNIbrain');
mask = brain_extraction( MNI );
imagesc(mask(:,:,45)); axis image

%% Compare with the MNI brain mask and with a threshold set by hand
MNImask = imgload('MNImask');
mask3000 = brain_extraction( MNI, 3000 );
fprintf('Voxels in the MNI mask: %d\n', sum(MNImask(:)));
fprintf('Default threshold: %d voxels, %d in the MNI mask\n', ...
    sum(mask(:)), sum(mask(:) & MNImask(:)));
fprintf('Threshold 3000: %d voxels, %d in the MNI mask\n', ...
    sum(mask3000(:)), sum(mask3000(:) & MNImask(:)));

%% Use the default threshold with a different skull erosion on a synthetic image
im = 10*rand(30,30,30); im(7:23,7:23,7:23) = 100; im(2:3,2:3,2:3) = 100;
mask = brain_extraction( im, [], 1 );
fprintf('Voxels in the mask: %d\n', sum(mask(:)));
