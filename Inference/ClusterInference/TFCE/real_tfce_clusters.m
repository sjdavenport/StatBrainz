function [ true_tfce_cluster_im, true_tfce_clusters ] = ... 
    real_tfce_clusters( tstat_orig, mask, tfce_threshold, H,E,connectivity_criterion,dh,h0)
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
D = length(size(mask));
if ~exist( 'connectivity_criterion', 'var' )
   % Default value
   if D == 2
       connectivity_criterion = 8;
   elseif D == 3
       connectivity_criterion = 26;
   end
end

if ~exist( 'H', 'var' )
   % Default value
   H = 2;
end

if ~exist( 'h0', 'var' )
   % Default value
   h0 = 0;
end

if ~exist( 'E', 'var' )
   % Default value
   E = 0.5;
end

if ~exist( 'dh', 'var' )
   % Default value
   dh = 0.1;
end
%%  Main Function Loop
%--------------------------------------------------------------------------
tstat_orig = tstat_orig.*mask;
% stat_greater_than_h_0 = tfce_tstat > h0;
% stat_greater_than_thresh = tfce_tstat > tfce_threshold;

% tfce_tstat = tfce(nan2zero(tstat_orig), H, E, connectivity_criterion, dh);
% [claimed_number_of_tfce_clusters, ~, ~, orig_index_locations] = numOfConComps(tfce_tstat, threshold_tfce, connectivity_criterion);
% [claimed_surviving_tfce_cluster_im, claimed_surviving_tfce_clusters] = cluster_im( size(mask), orig_index_locations, 0.5 );

[real_number_of_tfce_clusters, ~, ~, real_index_locations] = numOfConComps(tstat_orig, h0 + eps, connectivity_criterion);
[ ~, ~, real_surviving_tfce_clusters_vec] = cluster_im( size(mask), real_index_locations, 0.5 );

max_tfce_within_real_clusters = zeros(1, real_number_of_tfce_clusters);
for I = 1:real_number_of_tfce_clusters
    cluster_mask = cluster_im( size(mask), real_surviving_tfce_clusters_vec(I), 0.5 );
    tfce_region = tfce(nan2zero(tstat_orig.*cluster_mask), H, E, connectivity_criterion, dh);
    max_tfce_within_real_clusters(I) = max(tfce_region(:));
end

real_survivor_indices = max_tfce_within_real_clusters > tfce_threshold;
true_tfce_clusters = real_surviving_tfce_clusters_vec(real_survivor_indices);
true_tfce_cluster_im = cluster_im( size(mask), true_tfce_clusters, 0.5 );

end

