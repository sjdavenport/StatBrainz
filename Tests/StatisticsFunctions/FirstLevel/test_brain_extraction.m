%% test_brain_extraction
% Tests of the brain_extraction function.
%--------------------------------------------------------------------------

%% A cube is kept and a small separate blob is removed
im = zeros(30, 30, 30);
im(8:22, 8:22, 8:22) = 100;
im(2:4, 26:28, 2:4) = 100;
cube = false(30, 30, 30); cube(8:22, 8:22, 8:22) = true;
mask = brain_extraction(im, 50);
assert(isequal(size(mask), size(im)))
assert(all(mask(:) == 0 | mask(:) == 1))
assert(isequal(logical(mask), cube))

%% Only the largest connected component is kept
im = zeros(40, 30, 30);
im(5:19, 8:22, 8:22) = 100;     % 15^3 voxels
im(25:34, 10:19, 10:19) = 100;  % 10^3 voxels
big = false(40, 30, 30); big(5:19, 8:22, 8:22) = true;
mask = brain_extraction(im, 50, 1);
assert(isequal(logical(mask), big))

%% Values equal to the threshold are not in the mask
im = zeros(30, 30, 30); im(8:22, 8:22, 8:22) = 50;
mask = brain_extraction(im, 50, 1);
assert(sum(mask(:)) == 0)

%% Default skull_erosion is 2: a cube of side 4 is eroded away
im = zeros(20, 20, 20); im(8:11, 8:11, 8:11) = 100;
mask = brain_extraction(im, 50);
assert(sum(mask(:)) == 0)
assert(isequal(logical(brain_extraction(im, 50, 2)), logical(mask)))
small = false(20, 20, 20); small(8:11, 8:11, 8:11) = true;
assert(isequal(logical(brain_extraction(im, 50, 1)), small))

%% The MNI T1 image gives a mask close to the MNI brain mask
MNI = imgload('MNIbrain');
MNImask = imgload('MNImask') > 0;
mask = brain_extraction(MNI, 3000) > 0;
overlap = sum(mask(:) & MNImask(:));
assert(overlap/sum(MNImask(:)) > 0.95 && overlap/sum(mask(:)) > 0.95)

%% Default threshold separates two intensity levels
rng(1)
im = 10*rand(30, 30, 30);
cube = false(30, 30, 30); cube(7:23, 7:23, 7:23) = true;  % 18% of voxels
im(cube) = 100 + 10*rand(sum(cube(:)), 1);
mask = brain_extraction(im);
assert(isequal(logical(mask), cube))

%% An empty threshold gives the default threshold
assert(isequal(brain_extraction(im, [], 1), brain_extraction(im, 50, 1)))
assert(isequal(brain_extraction(im, []), brain_extraction(im)))

%% The default threshold lies in the largest gap between quantiles 0.2 and 0.85
% Values 1, 10 and 20: the gaps are 9 and 10, so the threshold is 15 and
% the voxel with value 10 is not in the mask
im = ones(20, 20, 20);
im(1:10, :, :) = 20;   % half of the voxels
im(1, 1, 1) = 10;
mask = brain_extraction(im, [], 0);
assert(mask(1, 1, 1) == 0 && sum(mask(:)) == 10*20*20 - 1)

%% The MNI T1 image with the default threshold gives a mask close to the MNI mask
MNI = imgload('MNIbrain');
MNImask = imgload('MNImask') > 0;
mask = brain_extraction(MNI) > 0;
overlap = sum(mask(:) & MNImask(:));
assert(overlap/sum(MNImask(:)) > 0.95 && overlap/sum(mask(:)) > 0.95)
