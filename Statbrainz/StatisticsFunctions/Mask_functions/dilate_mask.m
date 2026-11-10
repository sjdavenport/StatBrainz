function dilated_mask = dilate_mask( mask, dilation )
% DILATE_MASK( mask, dilation ) dilates the mask by dilation voxels. Note
% that if dilation is negative the mask is eroded! 
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%    mask        a logical array giving the mask
% Optional
%    dilation    the number of voxels by which to dilate the mask. Note
%    that if this is taken to be negative then the mask is eroded. Default
%    is 1, i.e. to dilate the mask by just one voxel.
%--------------------------------------------------------------------------
% OUTPUT
%   dilated_mask  an array with the same number of dimensions as mask that
%   is the dilated mask.
%--------------------------------------------------------------------------
% Copyright (C) - 2025 - Samuel Davenport
%--------------------------------------------------------------------------

%%  add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'dilation', 'var' )
   % default option of dilation
   dilation = 1;
end

%%  Main Function
%--------------------------------------------------------------------------
if dilation > 0
    dilated_mask = box_dilate( mask, dilation ); %Dilation
elseif dilation < 0
    dilated_mask = ~box_dilate( ~mask, abs(dilation) ); %Erosion
else
    dilated_mask = mask; %I.e. return the original mask if htere is no dilation
end

dilated_mask = logical( dilated_mask );

end

