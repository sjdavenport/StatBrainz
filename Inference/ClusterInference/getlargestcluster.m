function clustermask = getlargestcluster( mask )
% GETLARGESTCLUSTER returns a binary mask corresponding to the largest
% connected component in the input binary mask.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  mask   a 2D or 3D binary array
%--------------------------------------------------------------------------
% OUTPUT
% clustermask   a binary array with the same size as mask containing only
%               the largest connected component
%--------------------------------------------------------------------------
% EXAMPLES
% mask = zeros(10,10);
% mask(2,2) = 1;
% mask(5:8, 5:8) = 1;
% clustermask = getlargestcluster(mask);
% imagesc(clustermask)
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
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
CC = bwconncomp( mask );
lengths = cellfun(@length, CC.PixelIdxList);
largestloc = find(lengths == max(lengths));
clusterindices = CC.PixelIdxList{largestloc};
clustermask = cluster_im( size(mask), {clusterindices}, 0.5 );
end

