function adj_matrix = adjacency_matrix( srf, metric )
% ADJACENCY_MATRIX Computes the adjacency matrix for a given surface.
%
%   adj_matrix = adjacency_matrix(srf, metric) computes the adjacency matrix
%   for the surface structure 'srf' with the specified metric.
%--------------------------------------------------------------------------
% ARGUMENTS
%   Mandatory
%       srf         - Surface structure.
%   Optional
%       metric      - Metric for adjacency (default: 'ones').
%--------------------------------------------------------------------------
% OUTPUT
%   adj_matrix      - Computed adjacency matrix. 
%--------------------------------------------------------------------------
% EXAMPLES
% See test_adjacency_matrix.m
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'metric', 'var' )
   % Default value
   metric = 'ones';
end

%%  Main Function Loop
%--------------------------------------------------------------------------
edg = SurfStatEdg( srf );
if strcmp(metric, 'ones')
    dist = ones(length(edg),1);
elseif strcmp(metric, 'dist') || strcmp(metric, 'distance')
    first_set = srf.vertices(edg(:,1),:);
    second_set = srf.vertices(edg(:,2),:);
    dist = double(sqrt(sum((first_set - second_set).^2,2))); 
end
adj_matrix = sparse(edg(:,1), edg(:,2), dist, srf.nvertices, srf.nvertices) + sparse(edg(:,2), edg(:,1), dist, srf.nvertices, srf.nvertices);

end

