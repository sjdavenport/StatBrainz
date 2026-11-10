%% test_expand2mask
% Tests for expand2mask: puts an image back into a 91 x 109 image at the
% bounds of a mask.
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
