function [ masksum2D ] = region_bndry2D( regions, mask )
% REGION_BNDRY2D( regions, mask ) computes a 2D boundary image by
% accumulating the boundaries of a set of 3D regions at slice 80.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  regions   a cell array of 3D binary masks, one per region.
%  mask      a 3D binary mask used to define non-boundary voxels.
%--------------------------------------------------------------------------
% OUTPUT
%  masksum2D   a 2D image (double) with accumulated region boundaries.

%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
masksum2D = zeros(2*[91,109,91]);
nonboundary_mask = 1-doubleim(mask);
nonboundary_mask = nonboundary_mask(:,:,80);
for I = 1:length(regions)
    doublemask = doubleim(regions{I});
    masksum2D = masksum2D + mask_bndry(doublemask(:,:,80), nonboundary_mask);
    nonboundary_mask = nonboundary_mask + doublemask(:,:,80);
end

end

