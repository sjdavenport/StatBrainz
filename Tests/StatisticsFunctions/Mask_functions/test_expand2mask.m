%% test_expand2mask
% Tests for expand2mask: puts an image back into an image of the size of
% a mask, at the bounds of the mask.
%--------------------------------------------------------------------------
rng(0)

%% 2D mask
mask = zeros(91, 109); mask(10:20, 30:45) = 1;
im = rand(11, 16);
out = expand2mask( im, mask );
assert( isequal( size(out), [91 109] ) )
assert( isequal( out(10:20, 30:45), im ) )
assert( abs( sum(out(:)) - sum(im(:)) ) < 1e-10 )

%% Inverse of cropping with mask_bounds
full = rand(91, 109) .* mask;
bounds = mask_bounds( mask );
assert( isequal( expand2mask( full(bounds{:}), mask ), full ) )

%% 3D mask with a 2D image uses the first two bounds
mask3 = zeros(91, 109, 91); mask3(10:20, 30:45, 40:50) = 1;
assert( isequal( expand2mask( im, mask3 ), out ) )

%% Padding enlarges the bounds
im = rand(13, 18);
out = expand2mask( im, mask, 1 );
assert( isequal( out(9:21, 29:46), im ) )

%% The output has the size of the mask, not a fixed MNI size
mask = zeros(30, 40); mask(5:9, 12:20) = 1;
im = rand(5, 9);
out = expand2mask( im, mask );
assert( isequal( size(out), [30 40] ) )
assert( isequal( out(5:9, 12:20), im ) && sum(out(:) ~= 0) == numel(im) )

%% 3D image and 3D mask give a 3D output
mask3 = zeros(20, 25, 15); mask3(3:8, 10:14, 6:9) = 1;
full3 = rand(20, 25, 15) .* mask3;
bounds = mask_bounds( mask3 );
out = expand2mask( full3(bounds{:}), mask3 );
assert( isequal( size(out), [20 25 15] ) && isequal( out, full3 ) )

%% 3D MNI mask: cropping and expanding gives the masked image back
MNImask = imgload('MNImask');
MNI = imgload('MNIbrain') .* MNImask;
bounds = mask_bounds( MNImask );
assert( isequal( expand2mask( MNI(bounds{:}), MNImask ), MNI ) )
