function [ region_masks, region_names ] = atlas_masks( atlas, get_boundary )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%    atlas 
% Optional
%    get_boundary
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% [ region_masks, region_names ] = atlas_masks( 'HOc', 1 )
% overlay_brain( [30,40,30], region_masks(1), {'red'})
%
% [ region_masks, region_names ] = atlas_masks( 'HOc', 1 )
% overlay_brain( [30,71,40], region_masks)
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'get_boundary', 'var' )
   % Default value
   get_boundary = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
sbdir = statbrainz_maindir;
if strcmp(atlas, 'HOc')
    atlas_loc = [sbdir,'Atlases/HarvardOxford/'];
    a = load([atlas_loc, 'atlas_region_masks.mat']);
    region_names = a.names;
    region_masks = a.region_masks;
elseif strcmp(atlas, 'HOc1mm')
    atlas_loc = [sbdir,'Atlases/HarvardOxford/'];
    region_names = getBrainRegionNames([atlas_loc, 'HarvardOxford-Cortical.xml']);
    region_masks = cell(1, length(region_names));
    for I = 1:length(region_names)
        region_masks{I} = get_mask('HOc1mm', region_names{I});
    end
elseif strcmp(atlas, 'HOsc')
    atlas_loc = [sbdir,'Atlases/HarvardOxford/'];
    a = load([atlas_loc, 'subcortical_atlas_region_masks.mat']);
    region_names = a.names;
    region_masks = a.region_masks;
end

if get_boundary == 1
    for I = 1:length(region_masks)
        region_masks{I} = mask_bndry(region_masks{I});
    end
end

end

