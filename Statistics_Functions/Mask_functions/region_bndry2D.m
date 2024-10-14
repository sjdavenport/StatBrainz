function [ masksum2D ] = region_bndry2D( regions, mask )
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

