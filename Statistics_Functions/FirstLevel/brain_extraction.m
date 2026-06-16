function [ mask ] = brain_extraction( brain_im, threshold, skull_erosion )
% BRAIN_EXTRACTION thresholds a brain image to create a mask.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  brain_im       A 3D or 4D brain image (matrix or nifti object)
%  threshold      Scalar value to use as the threshold for creating the mask
% Optional
%  skull_erosion  Number of erosion steps to remove skull. Default is 2.
%--------------------------------------------------------------------------
% OUTPUT
%  mask           A binary mask of the same size as brain_im, where voxels
%                 above the threshold are set to 1, and voxels below or equal
%                 to the threshold are set to 0.
%--------------------------------------------------------------------------
% EXAMPLES
% See fsl_reg_data.m
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
% This function is inspired by the compute_epi_mask from the python
% nilearn package.
%--------------------------------------------------------------------------

if ~exist('skull_erosion', 'var')
    skull_erosion = 2;
end

mask = brain_im > threshold;
mask = dilate_mask(mask, -skull_erosion);

[~,~, cluster_sizes,index_locations] = numOfConComps(mask, 0.5, 6);
max_cluster_size = max(cluster_sizes);
for I = 1:length(index_locations)
    I
    if length(index_locations{I}) == max_cluster_size
        mask = cluster_im( size(mask), index_locations(I), 1 );
        break
    end
end

mask = dilate_mask(mask, 2*skull_erosion);
mask = dilate_mask(mask, -skull_erosion);

end
