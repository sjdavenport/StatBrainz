function [ dilated_mask ] = srf_dilate_mask( srf, mask, dilation )
% SRF_DILATE_MASK Dilates or erodes a mask on a surface.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  srf       surface structure
%  mask      logical mask vector over vertices
%  dilation  integer number of dilation steps; positive to dilate, negative
%            to erode, 0 returns mask unchanged
%--------------------------------------------------------------------------
% OUTPUT
%  dilated_mask  logical mask after dilation/erosion
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
if dilation == 0 
    dilated_mask = mask;
elseif dilation > 0
    mask = double(mask);
    dilated_mask = smooth_surface(srf, mask, 0, 'ones', dilation ) > 0;
else
    outside_mask = 1 - mask;
    outside_mask_dilated = srf_dilate_mask( srf, outside_mask, -dilation );
    dilated_mask = 1 - outside_mask_dilated;
end

end

