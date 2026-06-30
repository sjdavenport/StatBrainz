%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the expand2mask function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NOTE: expand2mask.m declares its function as expand2MNI (file/name
% mismatch); MATLAB dispatches on the file name, so call expand2mask.
rng(0)
mask = imgload('MNImask');
bounds = mask_bounds(mask);
bounded_mask = mask(bounds{:});
im = rand(size(bounded_mask, 1), size(bounded_mask, 2));
out = expand2mask(im, mask);
size(out)
