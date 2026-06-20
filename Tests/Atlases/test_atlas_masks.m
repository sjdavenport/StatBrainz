%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the atlas_masks function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ region_masks, region_names ] = atlas_masks( 'HOc', 1 )
overlay_brain( [30,40,30], region_masks(1), {'red'})

%% Overlay all regions
[ region_masks, region_names ] = atlas_masks( 'HOc', 1 )
overlay_brain( [30,71,40], region_masks)
