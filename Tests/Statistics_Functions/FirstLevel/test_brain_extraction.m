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
