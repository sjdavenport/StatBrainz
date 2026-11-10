%% test_gen_mask
% Tests of the gen_mask function.
%--------------------------------------------------------------------------
rng(5)
MNImask = imgload('MNImask');
nvox = numel(MNImask);

%% Full subject masks give the MNI mask (default 3D output)
data = ones(3, nvox);
mask = gen_mask(data);
assert(isequal(size(mask), [91, 109, 91]))
assert(isequal(mask > 0, MNImask > 0))

%% Intersection with the subject masks
data = double(rand(2, nvox) > 0.3);
mask = gen_mask(data);
expected = (MNImask(:) > 0) & all(data > 0, 1)';
assert(isequal(mask(:) > 0, expected))

%% make3D = 0 gives a vector
mask = gen_mask(data, 1, 0);
assert(isequal(size(mask), [nvox, 1]))
assert(isequal(mask > 0, expected))

%% use_MNI = 0 gives the intersection of the subject masks only
global stdsize
stdsize = [2, 3];
data = [1 1 0 1 1 1; 1 0 0 1 1 1];
mask = gen_mask(data, 0, 0);
assert(isequal(mask, [1; 0; 0; 1; 1; 1]))
