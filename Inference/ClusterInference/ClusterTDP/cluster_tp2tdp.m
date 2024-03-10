function [ tdp_bounds ] = cluster_tp2tdp( tp_bounds, clusters )
% CLUSTER_TP2TDP Converts true positives to true discovery proportion.
%
%   tdp_bounds = CLUSTER_TP2TDP(tp_bounds, clusters) converts true positive bounds
%   to true discovery proportion based on the given cluster sizes.
%--------------------------------------------------------------------------
% ARGUMENTS:
%   - tp_bounds: True positive bounds.
%   - clusters: Cell array containing cluster indices.
%
% OUTPUT:
%   - tdp_bounds: True discovery proportion bounds.
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
cluster_sizes = zeros(1, length(clusters));
for I = 1:length(clusters)
    cluster_sizes(I) = length(clusters{I});
end
tdp_bounds = tp_bounds./cluster_sizes;

end

