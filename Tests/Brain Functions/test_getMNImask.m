%% test_getMNImask
% Tests of the getMNImask function.
%--------------------------------------------------------------------------
[ MNImask, bounds ] = getMNImask;
full_mask = imgload('MNImask');

%% Output size and type
assert(isequal(size(MNImask), [72, 90, 77]))
assert(islogical(MNImask))
assert(iscell(bounds) && length(bounds) == 3)

%% The bounds crop the full mask to MNImask
assert(isequal(MNImask, logical(full_mask(bounds{:}))))

%% No brain voxels are lost
assert(sum(MNImask(:)) == sum(full_mask(:) > 0))

%% The box is the smallest one: each face has a brain voxel
assert(any(any(MNImask(1, :, :))) && any(any(MNImask(end, :, :))))
assert(any(any(MNImask(:, 1, :))) && any(any(MNImask(:, end, :))))
assert(any(any(MNImask(:, :, 1))) && any(any(MNImask(:, :, end))))
