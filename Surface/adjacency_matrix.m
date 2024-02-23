function adj_matrix = adjacency_matrix( srf, metric )
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

