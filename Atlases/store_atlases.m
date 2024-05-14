sbdir = statbrainz_maindir;
atlas_loc = [sbdir,'Atlases/HarvardOxford/'];
names = getBrainRegionNames([atlas_loc, 'HarvardOxford-Cortical.xml']);
region_masks = cell(1, length(names));
for I = 1:length(names)
    region_masks{I} = get_mask('HOc', names{I});
end

save([atlas_loc, 'atlas_region_masks'], 'names', 'region_masks')