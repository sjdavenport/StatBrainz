%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the get_mask function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mask = get_mask('HOsc', 'amygdala');
slice = bestclusterslice(0, mask);
overlay_brain(slice, {mask}, {'red'})

%% Fusiform
mask = get_mask('HOc', 'fusiform');
slice = bestclusterslice(0, mask);
overlay_brain(slice, {mask}, {'red'})

%% Hippocampus (separate hemispheres)
mask = get_mask('HOsc', 'Hippocampus', 0);
slice = bestclusterslice(0, mask);
overlay_brain(slice, {mask}, {'red'})

%% Middle Frontal Gyrus
mask = get_mask('HOc', 'Middle Frontal Gyrus');
slice = bestclusterslice(0, mask);
overlay_brain(slice, {mask}, {'red'})

%% All HOc regions
mask = get_mask('HOc', 'all');
slice = bestclusterslice(0, mask);
overlay_brain(slice, {mask}, {'red'})

%% All HOsc regions
mask = get_mask('HOsc', 'all');
slice = bestclusterslice(0, mask);
overlay_brain(slice, {mask}, {'red'})

%% All Juelich regions
mask = get_mask('Juelich', 'all');
slice = bestclusterslice(0, mask);
overlay_brain(slice, {mask}, {'red'})

%% All Talairach regions
mask = get_mask('Talairach', 'all');
slice = bestclusterslice(0, mask);
overlay_brain(slice, {mask}, {'red'})
