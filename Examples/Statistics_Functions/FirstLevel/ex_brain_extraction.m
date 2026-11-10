%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the brain_extraction function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Extract a brain mask from the MNI T1 image
MNI = imgload('MNIbrain');
mask = brain_extraction( MNI, 3000 );
imagesc(mask(:,:,45)); axis image

%% Compare with the MNI brain mask
MNImask = imgload('MNImask');
fprintf('Voxels in the mask: %d, in the MNI mask: %d, in both: %d\n', ...
    sum(mask(:)), sum(MNImask(:)), sum(mask(:) & MNImask(:)));

%% Use a different skull erosion on a synthetic image
im = zeros(30,30,30); im(8:22,8:22,8:22) = 100; im(2:3,2:3,2:3) = 100;
mask = brain_extraction( im, 50, 1 );
fprintf('Voxels in the mask: %d\n', sum(mask(:)));
