function [pvals, max_tstat_within_region] = localized_vi( ... 
                                    tstat_orig, region_masks, vec_of_maxima)
% LOCALIZED_VI( tstat_orig, region_masks, vec_of_maxima)
% implements localized voxelwise inference.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  tstat_orig: a 2D or 3D matlab arraya giving the test-statistic at each
%              pixel/voxel
%  region_masks: a cell array of length nregions where the ith entry is a 
%         mask corresponding to the ith region desired to compute a
%         localized pvalue of
%  vec_of_maxima: a vector of the values taken in the different permutations
%--------------------------------------------------------------------------
% OUTPUT
% pvals: a vector of 
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~iscell(region_masks)
    region_masks = {region_masks};
end

%%  Main Function Loop
%--------------------------------------------------------------------------
nmasks = length(region_masks);
max_tstat_within_region = zeros(1, nmasks);
for I = 1:nmasks
    region_mask = region_masks{I};
    masked_tstat = nan2zero(tstat_orig.*region_mask);
    max_tstat_within_region(I) = max(masked_tstat(:));
end
pvals = distbn2pval(vec_of_maxima, max_tstat_within_region);

end
