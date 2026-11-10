%% test_brain_extraction3
% Tests of the brain_extraction3 function.
%--------------------------------------------------------------------------

%% A hollow cube: holes are filled and the mask is eroded
im = zeros(30, 30, 30);
im(8:22, 8:22, 8:22) = 100;
im(12:18, 12:18, 12:18) = 0;
[mask, filled_mask] = brain_extraction3(im, 50, 1);
assert(isequal(size(mask), size(im)) && isequal(size(filled_mask), size(im)))
cube = false(30, 30, 30); cube(8:22, 8:22, 8:22) = true;
assert(isequal(logical(filled_mask), cube))
% mask = (im > 50) inside the cube eroded by 1: 13^3 - 7^3 voxels
expected = false(30, 30, 30); expected(9:21, 9:21, 9:21) = true;
expected(12:18, 12:18, 12:18) = false;
assert(isequal(logical(mask), expected))
assert(sum(mask(:)) == 13^3 - 7^3)

%% Default skull_erosion is 3
[mask, filled_mask] = brain_extraction3(im, 50);
expected = false(30, 30, 30); expected(11:19, 11:19, 11:19) = true;
expected(12:18, 12:18, 12:18) = false;
assert(isequal(logical(mask), expected))
assert(isequal(logical(filled_mask), cube))

%% Only the largest connected component is kept
im = zeros(40, 30, 30);
im(5:19, 8:22, 8:22) = 100;
im(25:34, 10:19, 10:19) = 100;
mask = brain_extraction3(im, 50, 1);
big = false(40, 30, 30); big(6:18, 9:21, 9:21) = true;
assert(isequal(logical(mask), big))

%% The filled mask uses the fixed lower threshold of 25
im = zeros(20, 20, 20); im(5:15, 5:15, 5:15) = 30;
[mask, filled_mask] = brain_extraction3(im, 50, 1);
assert(sum(mask(:)) == 0)
assert(sum(filled_mask(:)) == 11^3)

%% The MNI T1 image gives a mask inside the MNI brain mask
MNI = imgload('MNIbrain');
MNImask = imgload('MNImask') > 0;
mask = brain_extraction3(MNI, 3000) > 0;
assert(sum(mask(:)) > 0)
assert(sum(mask(:) & MNImask(:))/sum(mask(:)) > 0.95)
