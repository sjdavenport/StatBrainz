function [ mask ] = brain_extraction2( brain_im )
% BRAIN_EXTRACTION2 thresholds a brain image to create a mask.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  brain_im  A 3D or 4D brain image (matrix or nifti object)
%--------------------------------------------------------------------------
% OUTPUT
%  mask      A binary mask of the same size as brain_im, where voxels
%            above the threshold are set to 1, and voxels below or equal
%            to the threshold are set to 0.
%--------------------------------------------------------------------------
% EXAMPLES
% See fsl_reg_data.m
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

lower_thresh = 0.2;
upper_thresh = 0.85;

lower_cutoff = floor(lower_thresh * length(sorted_input)))

im_data_sorted = sort(brain_im(:));
threshold = prctile(vec_of_max_cluster_sizes, 100*(1-alpha) );

brain_im = brain_im/max(brain_im(:));
bin_locs = h.BinEdges;
bin_vals = h.Values;
min_loc = find(bin_vals == min(bin_vals));

threshold = bin_vals(min_loc);

mask = brain_im > threshold;

end
