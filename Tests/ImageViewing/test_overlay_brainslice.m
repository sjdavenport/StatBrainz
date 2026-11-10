%% test_overlay_brainslice
% Tests of the overlay_brainslice function (smoke tests, figures off).
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')
MNIbrain = imgload('MNIbrain.nii.gz');
MNIbrain = MNIbrain/max(MNIbrain(:));
region = MNIbrain > 0.8;

%% MNI brain only, in each of the three planes
slices = {[30, 0, 0], [0, 40, 0], [0, 0, 45]};
for I = 1:3
    figure; ax = overlay_brainslice( slices{I} );
    assert(~isempty(ax))
    if exist('isgraphics') > 0, assert(isgraphics(ax, 'axes')), end
end

%% With a region mask, colour and transparency
figure; ax = overlay_brainslice( [0, 0, 45], {region}, 'red', 0.6 );
assert(~isempty(ax))

%% A 2D region mask
figure; ax = overlay_brainslice( [0, 0, 45], {region(:,:,45)}, {'red'} );
assert(~isempty(ax))

%% Upsampled, with an underlay image
figure; ax = overlay_brainslice( [0, 0, 45], {NaN}, {NaN}, 1, zero2nan(region), 1 );
assert(~isempty(ax))
figure; ax = overlay_brainslice( [0, 0, 45], {region}, {'red'}, 1, [], 1 );
assert(~isempty(ax))

%% Other rotations, no brain mask, white background and padding
for rotate = 1:4
    figure; ax = overlay_brainslice( [0, 40, 0], {region}, {'blue'}, 1, [], 0, rotate, 0, 0, 5 );
    assert(~isempty(ax))
end
close all
