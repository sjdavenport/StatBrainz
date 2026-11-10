%% test_atlas_masks
% Tests of the atlas_masks function.
%--------------------------------------------------------------------------
HOdir = [statbrainz_maindir, 'Atlases/HarvardOxford/'];

%% HOc: one mask for each cortical region
[region_masks, region_names] = atlas_masks('HOc');
HOc_names = getBrainRegionNames([HOdir, 'HarvardOxford-Cortical.xml']);
assert(length(region_masks) == 48 && length(region_names) == 48)
assert(isequal(region_names, HOc_names))
assert(isequal(size(region_masks{1}), [91, 109, 91]))

%% HOc masks agree with the atlas image
HOc = imgload([HOdir, 'HarvardOxford-cort-maxprob-thr25-2mm.nii.gz']);
for I = [1, 20, 48]
    assert(isequal(region_masks{I} > 0, HOc == I))
end

%% get_boundary = 0 is the default
region_masks0 = atlas_masks('HOc', 0);
assert(isequal(region_masks0, region_masks))

%% get_boundary = 1 gives the outer boundary of each region
bndry_masks = atlas_masks('HOc', 1);
for I = [1, 20]
    assert(isequal(bndry_masks{I}, mask_bndry(region_masks{I})))
    assert(sum(bndry_masks{I}(:) > 0) > 0)
    assert(all(region_masks{I}(bndry_masks{I} > 0) == 0))
end

%% HOsc: one mask for each sub-cortical region
[region_masks, region_names] = atlas_masks('HOsc');
HOsc = imgload([HOdir, 'HarvardOxford-sub-maxprob-thr25-2mm.nii.gz']);
assert(length(region_masks) == 21)
assert(strcmp(region_names{10}, 'Left Amygdala'))
assert(isequal(region_masks{10} > 0, HOsc == 10))
