function [ mask ] = brain_extraction( brain_im, threshold, skull_erosion )
% BRAIN_EXTRACTION thresholds a brain image to create a mask.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  brain_im       A 3D or 4D brain image (matrix or nifti object)
% Optional
%  threshold      Scalar value to use as the threshold for creating the
%                 mask. Set it to [] to use the default. Default is the
%                 threshold of nilearn's compute_epi_mask: the midpoint of
%                 the largest gap between consecutive sorted intensities
%                 that lie between the 20% and 85% quantiles of brain_im.
%  skull_erosion  Number of erosion steps to remove skull. Default is 2.
%--------------------------------------------------------------------------
% OUTPUT
%  mask           A binary mask of the same size as brain_im, where voxels
%                 above the threshold are set to 1, and voxels below or equal
%                 to the threshold are set to 0.
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
% This function is inspired by the compute_epi_mask from the python
% nilearn package.
%--------------------------------------------------------------------------

if ~exist('skull_erosion', 'var')
    skull_erosion = 2;
end

if ~exist('threshold', 'var') || isempty(threshold)
    % Default value: the largest gap in the sorted intensities between the
    % 20% and 85% quantiles (as in nilearn's compute_epi_mask)
    sorted_im = sort(brain_im(:));
    n = length(sorted_im);
    lower_cutoff = floor(0.2*n);
    upper_cutoff = min(floor(0.85*n), n - 1);
    delta = sorted_im(lower_cutoff+2:upper_cutoff+1) - sorted_im(lower_cutoff+1:upper_cutoff);
    [~, ia] = max(delta);
    threshold = (sorted_im(lower_cutoff+ia) + sorted_im(lower_cutoff+ia+1))/2;
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
