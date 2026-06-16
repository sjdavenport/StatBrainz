function [ mask, filled_mask ] = brain_extraction( brain_im, threshold, skull_erosion )
% BRAIN_EXTRACTION3 thresholds a brain image to create a mask with
% hole-filling.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  brain_im       A 3D or 4D brain image (matrix or nifti object)
%  threshold      Scalar value to use as the threshold for creating the mask
% Optional
%  skull_erosion  Number of erosion steps to remove skull. Default is 3.
%--------------------------------------------------------------------------
% OUTPUT
%  mask           A binary mask restricted to the largest connected component
%  filled_mask    A hole-filled version of the lower-threshold binary mask
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

