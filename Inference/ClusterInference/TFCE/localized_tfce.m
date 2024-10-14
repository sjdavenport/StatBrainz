function [pvals, max_tfce_within_region] = localized_tfce( ... 
    tstat_orig, region_masks, vec_of_maxima, H, E, connectivity_criterion, dh, h0, show_loader)
% LOCALIZED_TFCE( tstat_orig, region_masks, vec_of_maxima, H, E, connectivity_criterion, dh, h0)
% embeds TFCE into a closed testing procedure. P-values are computed by 
% recalculating the TFCE.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  tstat_orig: a 2D or 3D matlab array giving the test-statistic at each
%              pixel/voxel
%  region_masks: a cell array of length nregions where the ith entry is a 
%         mask corresponding to the ith region desired to compute a
%         localized pvalue of
%  vec_of_maxima: a vector of the values taken in the different permutations
% Optional
%  H: height exponent (default is 2)
%  E: extent exponent (default is 0.5)
%  connectivity_criterion: connectivity used to compute the connected components
%  dh: size of steps for cluster formation. Default is 0.1.
%  h0: the cluster forming threshold - Default is h0 = 3.1.
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

if ~exist( 'show_loader', 'var' )
   % Default value
   show_loader = 1;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
nmasks = length(region_masks);
max_tfce_within_region = zeros(1, nmasks);

for I = 1:nmasks
    if show_loader == 1
        loader(I, nmasks, 'Progress:');
    end
    region_mask = region_masks{I};
    if ~isequal(size(region_mask), [91,109,91])
        region_mask = index2mask( region_mask );
    end
    tfce_region = tfce(nan2zero(tstat_orig.*region_mask), H, E, connectivity_criterion, dh, h0);
    max_tfce_within_region(I) = max(tfce_region(:));
end
pvals = distbn2pval(vec_of_maxima, max_tfce_within_region);

end

