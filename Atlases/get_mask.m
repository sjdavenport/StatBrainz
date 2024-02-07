function [ mask, indices, areas ] = get_mask( atlas_name, region_name, together )
% GET_MASK( atlas_name, region_name, together ) finds the areas of the 
% brain that contian the region_name and returns a mask of the union of 
% these areas as well as listing the areas and their indices
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%   atlas_name - name of the atlas to use
%   region_name - name of the region to find
% Optional
%   together - boolean indicating whether to combine the areas into a single mask (default: true)
%--------------------------------------------------------------------------
% OUTPUT
%   mask - binary mask of the union of the found areas
%   indices - indices of the found areas
%   areas - names of the found areas
%--------------------------------------------------------------------------
% EXAMPLES
% mask = get_mask('HOsc', 'amygdala');
% viewbrain(mask, [0,0,25])
%
% mask = get_mask('HOc', 'fusiform');
% viewbrain(mask, [0,0,26])
% mask = get_mask('HOc', 'fusiform', 0);
% viewbrain(mask, [0,0,26])
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------
if ~exist('together', 'var')
   together = 1; 
end

if strcmp(atlas_name, 'HOc')
    atlas_loc = 'C:\Users\12SDa\davenpor\davenpor\Toolboxes\StatBrainz\Atlases\HarvardOxford\';
    names = getBrainRegionNames([atlas_loc, 'HarvardOxford-Cortical.xml']);
    atlas_filename = 'HarvardOxford-cort-maxprob-thr25-2mm.nii.gz';
elseif strcmp(atlas_name, '15')
    atlas_loc = 'C:\Users\12SDa\davenpor\davenpor\Toolboxes\StatBrainz\Atlases\Derived_HarvardOxford\';
    names = getBrainRegionNames([atlas_loc, 'HarvardOxford-Cortical.xml']);
    atlas_filename = 'HarvardOxford-cort-maxprob-thr25-115_nearest.nii.gz';
elseif strcmp(atlas_name, 'HOsc')
    atlas_loc = 'C:\Users\12SDa\davenpor\davenpor\Toolboxes\StatBrainz\Atlases\HarvardOxford\';
    names = getBrainRegionNames([atlas_loc, 'HarvardOxford-Subcortical.xml']);
    atlas_filename = 'HarvardOxford-sub-maxprob-thr25-2mm.nii.gz';
end

if strcmp(region_name, 'all')
    indices = 1:length(names);
    areas = names;
else
    [indices, areas] = findstrings(lower(names), lower(region_name));
end
    
atlas = imgload([atlas_loc, atlas_filename]);
mask = zeros(size(atlas));
for I = 1:length(areas)
    fprintf([num2str(indices(I)), ': ',capstr(areas{I}), '\n'])
    if together
        mask = mask + (atlas == indices(I));
    else
        mask = mask + I*(atlas == indices(I));
    end
end

end

