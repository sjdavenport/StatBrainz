%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the pad_vals function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1D example
pad_vals( ones(1,3), 2 )

%% 2D example with different padding for each side
% Pads 1 voxel on the left and 2 on the right in the first dimension and
% 2 voxels on the top and 1 on the bottom in the second dimension
pad_vals( ones(2), [1 2; 2 1] )

%% Pad an MNI mask so that voxels on the edge of the image are inside it
MNImask = imgload('MNImask');
[ padded_mask, locs ] = pad_vals( MNImask, 1, 0 );
size(MNImask)
size(padded_mask)
isequal(padded_mask(locs{:}), MNImask)
