%% test_loadsubs
% Tests of the loadsubs function.
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
MNImask = imgload('MNImask');
bounds = mask_bounds( MNImask );

%% Default output: vectors within the bounding box of the MNI mask
[data, bounded_mask] = loadsubs( 1:nsubj, directory );
assert(isequal(bounded_mask, MNImask(bounds{:})))
assert(isequal(size(data), [numel(bounded_mask), nsubj]))
for I = 1:nsubj
    sub = subs{I}(bounds{:});
    assert(isequal(data(:, I), sub(:)))
end

%% A subset of the subjects, in the order given
data = loadsubs( [3, 1], directory );
sub3 = subs{3}(bounds{:});
sub1 = subs{1}(bounds{:});
assert(isequal(data, [sub3(:), sub1(:)]))

%% As 3D
data = loadsubs( 1:2, directory, 0, MNImask, 1 );
assert(isequal(size(data), [size(bounded_mask), 2]))
assert(isequal(data(:,:,:,2), subs{2}(bounds{:})))

%% A smaller mask crops to its bounding box
mask = false(91, 109, 91);
mask(10:20, 30:35, 40:41) = 1;
[data, bm] = loadsubs( 1, directory, 0, mask, 1 );
assert(isequal(size(bm), [11, 6, 2]))
assert(isequal(data, subs{1}(10:20, 30:35, 40:41)))

%% Given file names
data = loadsubs( 2, directory, 0, MNImask, 0, {'sub1.nii', 'sub3.nii'} );
assert(isequal(data, sub3(:)))

rmdir(directory, 's');
