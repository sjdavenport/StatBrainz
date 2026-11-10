%% test_getregion
% Tests of the getregion function.
%--------------------------------------------------------------------------
HOdir = [statbrainz_maindir, 'Atlases/HarvardOxford/'];
HOc = imgload([HOdir, 'HarvardOxford-cort-maxprob-thr25-2mm.nii.gz']);
HOsc = imgload([HOdir, 'HarvardOxford-sub-maxprob-thr25-2mm.nii.gz']);
HOc_names = getBrainRegionNames([HOdir, 'HarvardOxford-Cortical.xml']);
HOsc_names = getBrainRegionNames([HOdir, 'HarvardOxford-Subcortical.xml']);

%% Region names agree with the atlas images
point = [35, 62, 23];
[c, sc] = getregion(point);
assert(iscell(c) && length(c) == 1 && iscell(sc) && length(sc) == 1)
if HOc(35, 62, 23) > 0
    assert(strcmp(c{1}, deblank(HOc_names{HOc(35, 62, 23)})))
else
    assert(isempty(c{1}))
end
assert(strcmp(sc{1}, deblank(HOsc_names{HOsc(35, 62, 23)})))

%% A cortical voxel
[x, y, z] = ind2sub(size(HOc), find(HOc == 1, 1));
[c, ~] = getregion([x, y, z]);
assert(strcmp(c{1}, 'Frontal Pole'))

%% A voxel outside the brain gives empty names
[c, sc] = getregion([1, 1, 1]);
assert(isempty(c{1}) && isempty(sc{1}))

%% Cell array of points
[x, y, z] = ind2sub(size(HOsc), find(HOsc == 10, 1));
[c, sc] = getregion({[1, 1, 1], [x, y, z]});
assert(length(c) == 2 && length(sc) == 2)
assert(strcmp(sc{2}, 'Left Amygdala'))

%% The derived atlas gives no sub-cortical names
[c, sc] = getregion(round([35, 62, 23]*1.15), '15');
assert(length(c) == 1 && isempty(sc{1}))
