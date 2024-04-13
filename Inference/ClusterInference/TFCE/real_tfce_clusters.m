function [ out ] = real_tfce_clusters( tfce_tstat, mask, tfce_threshold, h0 )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'h_0', 'var' )
   % Default value
   h0 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
tfce_tstat = tfce_tstat.*mask;
stat_greater_than_h_0 = tfce_tstat > h0;
stat_greater_than_thresh = tfce_tstat > tfce_threshold;

[orig_number_of_tfce_clusters, ~, ~, index_locations] = numOfConComps(tfce_tstat, threshold_tfce, connectivity_criterion);
[ orig_surviving_tfce_cluster_im, orig_surviving_tfce_clusters] = cluster_im( size(mask), index_locations, 0.5 );

[real_number_of_tfce_clusters, ~, ~, index_locations] = numOfConComps(tfce_tstat, h0 + eps, connectivity_criterion);
[ real_surviving_tfce_cluster_im, real_surviving_tfce_clusters] = cluster_im( size(mask), index_locations, 0.5 );

    tfce_region = tfce(nan2zero(tstat_orig.*region_mask), H, E, connectivity_criterion, dh);
    max_tfce_within_region(I) = max(tfce_region(:));

end

