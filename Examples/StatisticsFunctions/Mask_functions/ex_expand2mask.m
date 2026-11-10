%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the expand2mask function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Crop the MNI brain to the bounds of the MNI mask and expand it back
MNImask = imgload('MNImask');
MNI = imgload('MNIbrain') .* MNImask;
bounds = mask_bounds(MNImask);
cropped = MNI(bounds{:});
out = expand2mask(cropped, MNImask);
size(cropped)
size(out)
isequal(out, MNI)

%% A 2D image with a 3D mask gives a 2D output of the first two dimensions
im = rand(length(bounds{1}), length(bounds{2}));
out = expand2mask(im, MNImask);
size(out)
imagesc(out); axis image

%% Use padding around the bounds of a small 2D mask
mask = zeros(20, 20); mask(8:12, 6:15) = 1;
[bounds, bounded_mask] = mask_bounds(mask, 2);
out = expand2mask(ones(size(bounded_mask)), mask, 2)
