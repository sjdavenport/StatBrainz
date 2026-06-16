function [HOc_regions, HOsc_regions] = getregion(points, atlas)
% GETREGION returns the region names at given coordinates in the atlas.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%   points  a 3-element integer vector, or a cell array of such vectors,
%           giving the voxel coordinate(s) to look up
% Optional
%   atlas   string identifying the atlas to use; 'default' uses both
%           Harvard-Oxford cortical and subcortical atlases (default: 'default')
%--------------------------------------------------------------------------
% OUTPUT
% HOc_regions   cell array of Harvard-Oxford Cortical region names for each point
% HOsc_regions  cell array of Harvard-Oxford Sub-cortical region names for each point
%               (empty when atlas is not 'default')
%--------------------------------------------------------------------------
%
% % Examples:
% point = [50, 60, 40]; % coordinates in MNI space
% getregion(point);
%
% point = [35,62,23];
% getregion(point)
%
% point = [35,62,23]*1.15;
% getregion(point, '15')
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

sbdir = statbrainz_maindir;
atlas_dir = [sbdir, 'Atlases/'];

if ~exist('atlas', 'var')
    atlas = 'default';
end
if strcmp(atlas, 'default') || strcmp(atlas, 'HOc')
    atlas_loc = [atlas_dir, 'HarvardOxford/'];
    HOc_names = getBrainRegionNames([atlas_loc, 'HarvardOxford-Cortical.xml']);
    atlas_filename = 'HarvardOxford-cort-maxprob-thr25-2mm.nii.gz';
    HOc_atlas = imgload([atlas_loc, atlas_filename]);
    
    HOsc_names = getBrainRegionNames([atlas_loc, 'HarvardOxford-Subcortical.xml']);
    atlas_filename = 'HarvardOxford-sub-maxprob-thr25-2mm.nii.gz';
    HOsc_atlas = imgload([atlas_loc, atlas_filename]);
elseif strcmp(atlas, '15')
    atlas_loc = [atlas_dir, 'Derived_HarvardOxford/'];
    HOc_names = getBrainRegionNames([atlas_loc, 'HarvardOxford-Cortical.xml']);
    atlas_filename = 'HarvardOxford-cort-maxprob-thr25-115_nearest.nii.gz';
    HOc_atlas = imgload([atlas_loc, atlas_filename]);
else
    fprintf('This atlas is not stored the options are default and HO_15\n')
end

if ~iscell(points)
    points = {points};
end

HOc_regions = cell(1, length(points));
HOsc_regions = cell(1, length(points));

for I = 1:length(points)
   	fprintf('Point %i\n', I)
    regionNum = HOc_atlas(points{I}(1), points{I}(2), points{I}(3));
    if regionNum == 0
        fprintf('Harvard-Oxford Cortical atlas: not found \n');
    else
        fprintf(['Harvard-Oxford Cortical atlas: ',HOc_names{regionNum}, '\n']);
        HOc_regions{I} = deblank(HOc_names{regionNum});
    end
    
    if strcmp(atlas, 'default')
        regionNum = HOsc_atlas(points{I}(1), points{I}(2), points{I}(3));
        if regionNum == 0
            fprintf('Harvard-Oxford Sub-cortical atlas: not found \n');
        else
            fprintf(['Harvard-Oxford Sub-cortical atlas: ', HOsc_names{regionNum}, '\n']);
            HOsc_regions{I} = deblank(HOsc_names{regionNum});
        end
    end
end

end
