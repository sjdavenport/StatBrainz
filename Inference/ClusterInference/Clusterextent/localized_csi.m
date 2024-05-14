function [pvals, max_cluster_within_region] = localized_csi( ... 
    tstat_orig, region_masks, vec_of_maxima, connectivity_criterion, CDT, show_loader)
% LOCALIZED_CSI( tstat_orig, region_masks, vec_of_maxima, connectivity_criterion, CDT, show_loader)
% implements localized cluster size inference which embeds clustersize
% inference into a closed testing procdure and procuces regional p-values. 
% P-values are computed by masking to a given region, calculating the size
% of the largest cluster on that region and comparing it to the 
% permutation/bootstrap distribution of the largest cluster sizes.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  tstat_orig: a 2D or 3D matlab arraya giving the test-statistic at each
%              pixel/voxel
%  region_masks: a cell array of length nregions where the ith entry is a 
%         mask corresponding to the ith region desired to compute a
%         localized pvalue of
%  vec_of_maxima: a vector of the values taken in the different permutations
% Optional
%  connectivity_criterion: connectivity used to compute the connected components
%  CDT: the cluster defining threshold, default is 3.1.
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

D = length(size(region_masks{1}));
if ~exist( 'connectivity_criterion', 'var' )
   % Default value
   if D == 2
       connectivity_criterion = 8;
   elseif D == 3
       connectivity_criterion = 26;
   end
end

if ~exist( 'CDT', 'var' )
   % Default value
   CDT = 3.1;
end

if ~exist( 'show_loader', 'var' )
   % Default value
   show_loader = 1;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
nmasks = length(region_masks);
max_cluster_within_region = zeros(1, nmasks);
for I = 1:nmasks
    if show_loader == 1
        loader(I, nmasks, 'Progress:');
    end
    region_mask = region_masks{I};
    [number_of_clusters, ~, sizes, ~] = numOfConComps(nan2zero(tstat_orig.*region_mask), CDT, connectivity_criterion);
    if number_of_clusters > 0
        max_cluster_within_region(I) = max(sizes);
    end
end
pvals = distbn2pval(vec_of_maxima, max_cluster_within_region);

end

% [ surviving_cluster_im, surviving_clusters, surviving_clusters_vec] = cluster_im( size(region_mask), index_locations, threshold_cluster );
% % numberofsurvivingclusters(I) = length(surviving_clusters_vec);