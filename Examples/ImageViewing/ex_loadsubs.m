%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the loadsubs function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save 3 example subject images to a temporary directory
directory = fullfile(tempdir, 'ex_loadsubs/');
if ~exist(directory, 'dir'), mkdir(directory); end
MNIbrain = imgload('MNIbrain.nii.gz');
for I = 1:3
    imgsave(MNIbrain + randn(size(MNIbrain)), sprintf('sub%d', I), directory)
end

%% Load subjects 1 and 3 as vectors within the bounding box of the MNI mask
[exsubs, bounded_mask] = loadsubs( [1,3], directory );
size(exsubs)

%% As 3D
MNImask = imgload('MNImask');
exsubs = loadsubs( 1:3, directory, 0, MNImask, 1 );
imagesc(exsubs(:,:,50,1))

%% Using a smaller mask
mask = false(size(MNImask)); mask(30:60, 40:70, 30:60) = 1;
exsubs = loadsubs( 1:2, directory, 0, mask, 1 );
size(exsubs)
