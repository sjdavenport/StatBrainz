%% test_loadbrains
% Tests of the loadbrains function.
%--------------------------------------------------------------------------
rng(1)
directory = [tempname, '/'];
mkdir(directory);
nsubj = 3;
subs = cell(1, nsubj);
for I = 1:nsubj
    subs{I} = randn(91, 109, 91);
    imgsave( subs{I}, sprintf('sub%d', I), directory )
end
subfilenames = {'sub1.nii', 'sub2.nii', 'sub3.nii'};
MNImask = imgload('MNImask');
bounds = mask_bounds( MNImask );

%% Default output: vectors within the bounding box of the MNI mask
[data, bounded_mask] = loadbrains( subfilenames, directory );
assert(isequal(bounded_mask, MNImask(bounds{:})))
assert(isequal(size(data), [numel(bounded_mask), nsubj]))
for I = 1:nsubj
    sub = subs{I}(bounds{:});
    assert(isequal(data(:, I), sub(:)))
end

%% As 3D
data = loadbrains( subfilenames, directory, MNImask, 1 );
assert(isequal(size(data), [size(bounded_mask), nsubj]))
assert(isequal(data(:,:,:,3), subs{3}(bounds{:})))

%% A subset of the subjects
data = loadbrains( subfilenames, directory, MNImask, 0, [3, 1] );
sub3 = subs{3}(bounds{:});
sub1 = subs{1}(bounds{:});
assert(isequal(data, [sub3(:), sub1(:)]))

%% A smaller mask crops to its bounding box
mask = false(91, 109, 91);
mask(10:20, 30:35, 40:41) = 1;
[data, bm] = loadbrains( subfilenames(2), directory, mask, 1 );
assert(isequal(size(bm), [11, 6, 2]))
assert(isequal(data, subs{2}(10:20, 30:35, 40:41)))

rmdir(directory, 's');
