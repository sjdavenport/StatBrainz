function overlay_brain3( slice, padding, region_masks, colors2use, alpha_val, underim, rotate, applybrainmask, upsample)
% overlay_brain3_dep - deprecated version: plots three-view brain overlays through a given slice.
%
%   overlay_brain3_dep(slice, padding, region_masks, colors2use, alpha_val, underim, rotate, applybrainmask, upsample)
%   overlays region masks on a three-panel brain slice image.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  slice          A 3-element numeric array specifying the slice coordinates
%                 [x, y, z] where the overlay will be applied.
% Optional
%  padding        A numeric value or 1x3 vector specifying the padding around
%                 slices. Default is [10,6,2].
%  region_masks   A cell array of region masks to overlay on the brain slice.
%                 Default is {NaN}.
%  colors2use     A string specifying the color of the overlay. Default is []
%                 (white is used).
%  alpha_val      A numeric value specifying the transparency of the overlay.
%                 Default is NaN.
%  underim        An underlay image. Default is [].
%  rotate         A numeric value specifying the rotation of the overlay.
%                 Default is 4.
%  applybrainmask 0/1 whether to apply the brain mask. Default is 1.
%  upsample       0/1 whether to use the 1mm MNI brain. Default is 0.
%--------------------------------------------------------------------------
% OUTPUT
%   None.
%--------------------------------------------------------------------------
% EXAMPLES
% MNIbrain = imgload('MNIbrain.nii.gz');
% MNIbrain = MNIbrain/max(MNIbrain(:));
% slice = 45;
% overlay_brain3([30,40,50], [], {MNIbrain > 0.8}, 'red', 0.6, 4)
% %--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist('region_masks', 'var')
    region_masks = {NaN};
end

if ~exist('alpha_val', 'var')
    alpha_val = NaN;
end

if ~exist('colors2use', 'var')
    colors2use = [];
end

if ~exist('padding', 'var') || isempty(padding)
    padding = [10,6,2];
end

if length(padding) == 1
    padding = repmat(padding, 1, 3);
end

if ~exist('underim', 'var')
    underim = [];
end

if ~exist('rotate', 'var')
    rotate = 4;
end

if ~exist('applybrainmask', 'var')
    applybrainmask = 1;
end

if ~exist('upsample', 'var')
    upsample = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
% subplot(1,3,1)
t = tiledlayout(1,3,'TileSpacing','None');
nexttile
region_masks_2D = cell(1,length(region_masks));
for I = 1:length(region_masks)
    region_masks_2D{I} = region_masks{I}(:,:,slice(3));
end
overlay_brain( [0,0,slice(3)], padding(1), region_masks_2D, colors2use, alpha_val, underim, rotate, applybrainmask, upsample)
% A = get(gca,'position');          % gca points at the second one
% A(1,4) = A(1,4)/3;
% A(1,1) = A(1,1);
% set(gca,'position',A);  

% subplot(1,3,2)
nexttile
region_masks_2D = cell(1,length(region_masks));
for I = 1:length(region_masks)
    region_masks_2D{I} = squeeze(region_masks{I}(:,slice(2),:));
end
overlay_brain( [0,slice(2),0], padding(2), region_masks_2D, colors2use, alpha_val, underim, rotate, applybrainmask, upsample)

% subplot(1,3,3)
nexttile
region_masks_2D = cell(1,length(region_masks));
for I = 1:length(region_masks)
    region_masks_2D{I} = squeeze(region_masks{I}(slice(1),:,:));
end
overlay_brain( [slice(1),0,0], padding(3), region_masks_2D, colors2use, alpha_val, underim, rotate, applybrainmask, upsample)

set(gcf, 'Color', 'black');
end

