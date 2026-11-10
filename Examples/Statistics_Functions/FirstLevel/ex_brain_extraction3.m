%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the brain_extraction3 function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Extract a brain mask from the MNI T1 image
MNI = imgload('MNIbrain');
[ mask, filled_mask ] = brain_extraction3( MNI, 3000 );
subplot(1,2,1); imagesc(mask(:,:,45)); axis image; title('mask')
subplot(1,2,2); imagesc(filled_mask(:,:,45)); axis image; title('filled mask')

%% Compare with the MNI brain mask
MNImask = imgload('MNImask');
fprintf('Voxels in the mask: %d, in the MNI mask: %d, in both: %d\n', ...
    sum(mask(:)), sum(MNImask(:)), sum(mask(:) & MNImask(:) > 0));

%% Use a different skull erosion on a synthetic image
im = zeros(30,30,30); im(8:22,8:22,8:22) = 100; im(12:18,12:18,12:18) = 0;
[ mask, filled_mask ] = brain_extraction3( im, 50, 1 );
fprintf('Voxels in the mask: %d, in the filled mask: %d\n', sum(mask(:)), sum(filled_mask(:)));
