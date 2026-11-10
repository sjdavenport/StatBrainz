%% test_voxinMNI
% Tests of the voxinMNI function.
%--------------------------------------------------------------------------
MNI = imgload('MNImask');

%% Vector index of a voxel in the brain
assert(voxinMNI(224913) == 1)
assert(voxinMNI(224913) == MNI(224913))

%% Vector index of a voxel outside the brain (the corner)
assert(voxinMNI(1) == 0)

%% Coordinate input gives the same answer as the vector index
assert(voxinMNI([52, 74, 23]) == MNI(52, 74, 23))
assert(voxinMNI([52, 74, 23]) == voxinMNI(224913))
assert(voxinMNI([1, 1, 1]) == 0)

%% Agrees with the mask at random voxels
rng(1)
locs = randi(numel(MNI), 1, 20);
for I = 1:length(locs)
    assert(voxinMNI(locs(I)) == MNI(locs(I)))
end
