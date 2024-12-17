%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the mgzwrite function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mask = MRIread('/Users/sdavenport/Documents/Data/Surface/Oasis_data/oasis_data_raw/disc1_freesurfer/OAS1_0001_MR1/mri/brainmask.mgz');
subplot(1,2,1)
imagesc(mask.vol(:,:,50))
axis off image
mgzwrite(mask.vol, '/Users/sdavenport/Documents/Code/MATLAB/MyPackages/StatBrainz/Tests/Surfaces/Reading_surface_data/test.mgz')
title('Original')
testim = MRIread('./test.mgz');
subplot(1,2,2)
imagesc(testim.vol(:,:,50))
axis off image
fullscreen
title('Saved and loaded')
BigFont(40)
