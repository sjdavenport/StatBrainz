%% Harvard Oxford Cortical
sbdir = statbrainz_maindir;
atlas_loc = [sbdir,'Atlases/HarvardOxford/'];
names = getBrainRegionNames([atlas_loc, 'HarvardOxford-Cortical.xml']);
region_masks = cell(1, length(names));
for I = 1:length(names)
    region_masks{I} = get_mask('HOc', names{I});
end

save([atlas_loc, 'atlas_region_masks'], 'names', 'region_masks')

%% Harvard Oxford Cortical 1mm
sbdir = statbrainz_maindir;
atlas_loc = [sbdir,'Atlases/HarvardOxford/'];
names = getBrainRegionNames([atlas_loc, 'HarvardOxford-Cortical.xml']);
region_masks = cell(1, length(names));
MNImask1mm = imgload('MNImask1mm') > 0;
for I = 1:length(names)
    region_masks{I} = get_mask('HOc1mm', names{I});
    % region_masks{I} = region_masks{I}(MNImask1mm);
end

save([atlas_loc, '1mm_atlas_region_masks'], 'names', 'region_masks')

%% Harvard Oxford Subcortical
sbdir = statbrainz_maindir;
atlas_loc = [sbdir,'Atlases/HarvardOxford/'];
names = getBrainRegionNames([atlas_loc, 'HarvardOxford-Subcortical.xml']);
region_masks = cell(1, length(names));
for I = 1:length(names)
    region_masks{I} = get_mask('HOsc', names{I});
end

save([atlas_loc, 'subcortical_atlas_region_masks'], 'names', 'region_masks')


%% Juelich
sbdir = statbrainz_maindir;
atlas_loc = [sbdir,'Atlases/Juelich/'];
names = getBrainRegionNames([atlas_loc, 'Juelich.xml']);
region_masks = cell(1, length(names));
for I = 1:length(names)
    region_masks{I} = get_mask('Juelich', names{I});
end

save([atlas_loc, 'atlas_region_masks'], 'names', 'region_masks')
