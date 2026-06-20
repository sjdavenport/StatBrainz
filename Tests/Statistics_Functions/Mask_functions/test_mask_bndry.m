%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the mask_bndry function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% 3D brain example
region_mask = get_mask('HOc', 'Middle Frontal Gyrus');
slice = bestclusterslice(0, region_mask);
[ outer_bndry, inner_bndry ] = mask_bndry( region_mask );
overlay_brain( slice, {region_mask, outer_bndry}, {'yellow', 'blue'})
overlay_brain( slice, {region_mask, inner_bndry}, {'yellow', 'red'})

%%
% 2D brain example
region_mask = get_mask('HOc', 'Middle Frontal Gyrus');
[ outer_bndry, inner_bndry ] = mask_bndry( region_mask(:,:,56) );
imagesc(region_mask(:,:,56))
add_region( outer_bndry, 'red')
