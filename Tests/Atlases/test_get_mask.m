%% test_get_mask
% Tests of the get_mask function.
%--------------------------------------------------------------------------
HOdir = [statbrainz_maindir, 'Atlases/HarvardOxford/'];
HOsc = imgload([HOdir, 'HarvardOxford-sub-maxprob-thr25-2mm.nii.gz']);
HOc = imgload([HOdir, 'HarvardOxford-cort-maxprob-thr25-2mm.nii.gz']);

%% Amygdala: the union of the left (10) and right (20) amygdala
[mask, indices, areas] = get_mask('HOsc', 'amygdala');
assert(isequal(indices, [10, 20]))
assert(length(areas) == 2)
assert(isequal(size(mask), [91, 109, 91]))
assert(isequal(mask, double(HOsc == 10 | HOsc == 20)))

%% The search is not case sensitive
mask2 = get_mask('HOsc', 'AMYGDALA');
assert(isequal(mask2, mask))

%% together = 0 labels the areas 1, 2, ...
mask = get_mask('HOsc', 'amygdala', 0);
assert(isequal(mask, 1*(HOsc == 10) + 2*(HOsc == 20)))

%% 'all' gives every region of the atlas
[mask, indices] = get_mask('HOc', 'all');
assert(isequal(indices, 1:48))
assert(isequal(mask > 0, HOc > 0))
