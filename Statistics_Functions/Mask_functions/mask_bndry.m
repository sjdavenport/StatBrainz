function [ outer_bndry,  inner_bndry ] = mask_bndry( mask, nonboundary_mask )
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
% % 3D brain example
% region_mask = get_mask('HOc', 'Middle Frontal Gyrus');
% slice = bestclusterslice(0, region_mask);
% [ outer_bndry, inner_bndry ] = mask_bndry( region_mask );
% overlay_brain( slice, {region_mask, outer_bndry}, {'yellow', 'blue'})
% overlay_brain( slice, {region_mask, inner_bndry}, {'yellow', 'red'})
% 
% % 2D brain example
% region_mask = get_mask('HOc', 'Middle Frontal Gyrus');
% [ outer_bndry, inner_bndry ] = mask_bndry( region_mask(:,:,56) );
% imagesc(region_mask(:,:,56))
% add_region( outer_bndry, 'red')
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
dilated_mask = dilate_mask( mask, 1);
shrunk_mask = dilate_mask( mask, -1);
inner_bndry = mask - shrunk_mask;
outer_bndry = dilated_mask - mask;

if exist( 'nonboundary_mask', 'var' )
   % Default value
   inner_bndry = inner_bndry.*(1-nonboundary_mask);
   outer_bndry = outer_bndry.*(1-nonboundary_mask);
end


end

