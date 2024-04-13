function [ mask, filled_mask ] = brain_extraction( brain_im, threshold, skull_erosion )
%BRAIN_THRESH Threshold a brain image to create a mask
%
%   [mask] = brain_thresh(brain_im, threshold)
%
%   Mandatory Arguments:
%   brain_im - A 3D or 4D brain image (matrix or nifti object)
%   threshold - Scalar value to use as the threshold for creating the mask
%
%   Output:
%   mask - A binary mask of the same size as brain_im, where voxels
%          above the threshold are set to 1, and voxels below or equal
%          to the threshold are set to 0.
%--------------------------------------------------------------------------
% EXAMPLES
% See fsl_reg_data.m
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

if ~exist('skull_erosion', 'var')
    skull_erosion = 3;
end
mask = brain_im > threshold;
lowerthreshmask = brain_im > 25;

filled_mask = zeros(size(mask));
for I = 1:size(mask,3)
    filled_mask(:,:,I) = imfill(lowerthreshmask(:,:,I), 'holes');
end
filled_mask_eroded = dilate_mask(filled_mask, -skull_erosion);

mask = mask.*filled_mask_eroded;
[~,~, cluster_sizes,index_locations] = numOfConComps(mask, 0.5, 6);
max_cluster_size = max(cluster_sizes);
for I = 1:length(index_locations)
    if length(index_locations{I}) == max_cluster_size
        mask = cluster_im( size(mask), index_locations(I), 1 );
    end
end

end

