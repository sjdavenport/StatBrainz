%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the upsample3_nn function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Double the size of a small 3D array
vol = reshape(1:8, [2,2,2]);
out = upsample3_nn( vol, 2 );
size(out)
out(:,:,1)

%% Use a different scale factor in each dimension
out = upsample3_nn( ones(4,6,8), [2, 1, 0.5] );
size(out)

%% Upsample the 2mm MNI mask to 1mm
MNImask = imgload('MNImask');
MNImask1mm = upsample3_nn( MNImask, 2 );
size(MNImask1mm)
imagesc(MNImask1mm(:,:,100)); axis image
