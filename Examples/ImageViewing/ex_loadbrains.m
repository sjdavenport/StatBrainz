%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the loadbrains function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save 3 example subject images to a temporary directory
directory = fullfile(tempdir, 'ex_loadbrains/');
if ~exist(directory, 'dir'), mkdir(directory); end
MNIbrain = imgload('MNIbrain.nii.gz');
for I = 1:3
    imgsave(MNIbrain + randn(size(MNIbrain)), sprintf('sub%d', I), directory)
end
subfilenames = filesindir(directory, '.nii');

%% Load all the subjects as vectors within the bounding box of the MNI mask
[exsubs, bounded_mask] = loadbrains( subfilenames, directory );
size(exsubs)

%% As 3D
MNImask = imgload('MNImask');
exsubs = loadbrains( subfilenames, directory, MNImask, 1 );
imagesc(exsubs(:,:,50,1))

%% Only load subjects 2 and 3
exsubs = loadbrains( subfilenames, directory, MNImask, 0, [2,3] );
size(exsubs)
