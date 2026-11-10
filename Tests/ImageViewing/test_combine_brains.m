%% test_combine_brains
% Tests of the combine_brains function.
%--------------------------------------------------------------------------
MNIbrain = imgload('MNIbrain.nii.gz');
MNImask = imgload('MNImask');
bounds = mask_bounds( MNImask );
L = cellfun(@length, bounds);
slice = [30, 40, 30];

%% Output size with padding 8
combined_im = combine_brains( MNIbrain, slice, MNImask, 8 );
assert(isequal(size(combined_im), [L(2), L(2) + 2*L(1) + 2*8]))

%% Default padding is 5
assert(isequal(combine_brains( MNIbrain, slice, MNImask ), combine_brains( MNIbrain, slice, MNImask, 5 )))

%% The third panel is the axial slice
B = MNIbrain(bounds{:});
s = slice - [bounds{1}(1), bounds{2}(1), bounds{3}(1)] + 1;
assert(isequal(combined_im(:, end-L(1)+1:end), flipud(B(:,:,s(3))')))

%% The second panel is the coronal slice
ystart = floor((L(2) - L(3))/2) + 3;
panel2 = combined_im(ystart:(ystart + L(3) - 1), (L(2)+9):(L(2)+8+L(1)));
assert(isequal(panel2, flipud(squeeze(B(:,s(2),:))')))

%% The padding columns are zero
assert(all(combined_im(:, (L(2)+1):(L(2)+8)) == 0, 'all'))

%% Outer padding {lower, upper} adds rows and columns
padded = combine_brains( MNIbrain, slice, MNImask, 8, {[9,9], [9,10]} );
assert(isequal(size(padded), size(combined_im) + [18, 19]))
padded = combine_brains( MNIbrain, slice, MNImask, 8, {2, 3} );
assert(isequal(size(padded), size(combined_im) + [5, 5]))

%% 1mm images use twice the padding
MNIbrain1mm = imgload('MNIbrain1mm.nii.gz');
MNImask1mm = imgload('MNImask1mm.nii.gz') > 0;
L1 = cellfun(@length, mask_bounds( MNImask1mm ));
combined_im = combine_brains( MNIbrain1mm, [60, 80, 60], MNImask1mm, 8 );
assert(isequal(size(combined_im), [L1(2), L1(2) + 2*L1(1) + 2*16]))

%% use_bounds = 0 with a scalar outer padding gives the full image
combined_im = combine_brains( MNIbrain, slice, MNImask, 8, 0, 0 );
assert(isequal(size(combined_im), [109, 291]))
assert(isequal(combined_im(:, 201:291), flipud(MNIbrain(:,:,slice(3))')))

%% use_bounds = 0 with the default outer padding
combined_im = combine_brains( MNIbrain, slice, MNImask, 8, {0, 0}, 0 );
assert(isequal(size(combined_im), [109, 291]))
