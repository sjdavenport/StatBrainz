function ax = overlay_brain( slice, region_masks, colors2use, alpha_val, underim, applybrainmask, upsample)
% overlay_brain - Overlay region masks on a brain slice image.
%
%   overlay_brain(slice, padding, region_masks, colors2use, alpha_val, rotate)
%   overlays region masks on a brain slice image. It takes the following
%   input arguments:
%
% Mandatory Inputs:
%   - slice: A 3-element numeric array specifying the slice coordinates
%
% Optional Inputs:
%   - region_masks: An optional cell array of region masks to overlay on
%                   the brain slice. Default is {NaN}.
%   - colors2use: An optional string specifying the color of the overlay.
%                 Default is an empty string ([]), which results in
%                 automatic color assignment.
%   - alpha_val: An optional numeric value specifying the transparency
%                of the overlay. Default is NaN (automatic transparency).
%   - rotate: An optional numeric value specifying the rotation of the
%             overlay. Default is 4.
%--------------------------------------------------------------------------
% Output:
%   - out: The output of the overlay operation (not specified in detail).
%--------------------------------------------------------------------------
% EXAMPLES:
%   To overlay a white matter region mask on a brain slice at coordinates
%   [0, 0, slice] with a padding of 10, red color, transparency of 0.75, and
%   rotation of 4, you can use the following command:
%
% MNIbrain = imgload('MNIbrain.nii.gz');
% MNIbrain = MNIbrain/max(MNIbrain(:));
% overlay_brain([30,40,50], {MNIbrain > 0.8}, 'red', 0.6, 4)
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
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

if ~exist('underim', 'var')
    underim = [];
end

if ~exist('applybrainmask', 'var')
    applybrainmask = 1;
end

if ~exist('upsample', 'var')
    upsample = 0;
end

if upsample
    slice = slice*2;
    underim = doubleim(underim);
    brain_im = imgload('MNIbrain1mm.nii.gz');
    brain_mask = imgload('MNImask1mm.nii.gz') > 0;
%     brain_mask_orig = imgload('MNImask');
%     brain_im = brain_im.*doubleim(brain_mask_orig);
%     brain_im = brain_im.*brain_mask;
else
    brain_im = imgload('MNIbrain.nii.gz');
    brain_mask = imgload('MNImask') > 0;
    brain_im = brain_im.*brain_mask;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
padding = 15;
brain_im4D = combine_brains(brain_im, slice, brain_mask, padding);
if ~isnan(region_masks{1})
    for I = 1:length(region_masks)
        region_masks{I} = combine_brains(region_masks{I}, slice, brain_mask, padding);
    end
end
% bounds = mask_bounds( brain_mask, padding );
% bounds = {1:91,1:109,1:91};

if applybrainmask
    brain_mask4D = combine_brains(brain_mask, slice, brain_mask, padding);
else
    brain_mask4D = ones(size(brain_im3D));
end

rotate = 1;
if any(isnan(underim(:)))
    brain_im_bw = ones([size(brain_im4D), 3]);
    brain_im_bw = squeeze(brain_im_bw.*brain_im4D/max(brain_im4D(:)));
    imagesc(brain_im_bw);
    hold on
    underim4D = combine_brains(underim, slice, brain_mask, padding);
    im1 = viewdata(underim4D, brain_mask4D, region_masks, colors2use, rotate, [], alpha_val);
    if max(underim4D(:)) > min(underim4D(:))
        caxis([min(underim4D(:)), max(underim4D(:))])
    end
else
    im1 = viewdata(brain_im4D, brain_mask4D, region_masks, colors2use, rotate, [], alpha_val);
    colormap('gray')
end

% axes('Units', 'normalized', 'Position', [0 0 1 1])
axis image
fullscreen;
ax = gca;
set(gcf, 'Color', 'black');

end

