%% test_viewbrain
% Tests of the viewbrain function (smoke tests, figures off).
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')
MNIbrain = imgload('MNIbrain.nii.gz');
MNIbrain = MNIbrain/max(MNIbrain(:));

%% Default slice and mask
figure; ax = viewbrain( MNIbrain );
assert(~isempty(ax))
if exist('isgraphics') > 0, assert(isgraphics(ax, 'axes')), end

%% Given slice
figure; ax = viewbrain( MNIbrain.*(MNIbrain > 0.8), [45, 50, 40] );
assert(~isempty(ax))

%% Given mask
figure; ax = viewbrain( MNIbrain, [30, 40, 50], imgload('MNImask') );
assert(~isempty(ax))
close all
