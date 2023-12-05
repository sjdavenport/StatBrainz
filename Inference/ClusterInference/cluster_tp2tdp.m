function [ tdp_bounds ] = cluster_tp2tdp( tp_bounds, clusters )
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
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
cluster_sizes = zeros(1, length(clusters));
for I = 1:length(clusters)
    cluster_sizes(I) = length(clusters{I});
end
tdp_bounds = tp_bounds./cluster_sizes;

end

