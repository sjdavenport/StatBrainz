%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the combine_brains function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MNIbrain = imgload('MNIbrain'); MNImask = imgload('MNImask');
combined_im = combine_brains( MNIbrain, [30,40,30], MNImask, 8);
imagesc(combined_im); fullscreen; axis off; axis image;

%%
MNIbrain1mm = imgload('MNIbrain1mm.nii.gz');
MNImask1mm = imgload('MNImask1mm.nii.gz') > 0;
combined_im = combine_brains( MNIbrain1mm, [60,80,60], MNImask1mm, 8);
imagesc(combined_im); fullscreen; axis off; axis image; colormap('gray')
