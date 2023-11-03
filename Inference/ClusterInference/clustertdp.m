function [ tdp_bounds, tp_bounds ] = clustertdp( clusters, cluster_threshold )
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
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
tp_bounds = zeros(1, length(clusters));
tdp_bounds = zeros(1, length(clusters));

for I = 1:length(clusters)
    clear CL
    CL.x = clusters{I}(:,1);
    CL.y = clusters{I}(:,2);
    CL.z = clusters{I}(:,3);
    tp_bounds(I) = clustertp_lowerbound(CL, cluster_threshold, 3);
    tdp_bounds(I) = tp_bounds(I)/length( CL.x );
end

end

