%% test_overlay_brain
% Tests of the overlay_brain function (smoke tests, figures off).
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')
MNIbrain = imgload('MNIbrain.nii.gz');
MNIbrain = MNIbrain/max(MNIbrain(:));
region = MNIbrain > 0.8;

%% MNI brain only
figure; ax = overlay_brain( [30, 40, 50] );
assert(~isempty(ax))
if exist('isgraphics') > 0, assert(isgraphics(ax, 'axes')), end

%% With a region mask, colour and transparency
figure; ax = overlay_brain( [30, 40, 50], {region}, {'red'}, 0.6 );
assert(~isempty(ax))

%% Two regions, no brain mask, no padding and a white background
figure; ax = overlay_brain( [30, 40, 50], {region, MNIbrain > 0.9}, {'red', 'blue'}, 1, [], 0, 0, {0, 0}, 0 );
assert(~isempty(ax))

%% An underlay image with NaN outside the region
underim = zero2nan(MNIbrain.*region);
figure; ax = overlay_brain( [30, 40, 50], {NaN}, [], 1, underim );
assert(~isempty(ax))
figure; ax = overlay_brain( [30, 40, 50], {region}, {'red'}, 0.6, underim, 1 );
assert(~isempty(ax))

%% Upsampled to 1mm with the default underlay
figure; ax = overlay_brain( [30, 40, 50], {region}, {'red'}, 0.6, [], 1 );
assert(~isempty(ax))
close all
