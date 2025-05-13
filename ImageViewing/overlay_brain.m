function ax = overlay_brain( slice, region_masks, colors2use, alpha_val, underim, upsample, applybrainmask, outerpadding, doblackbackground)
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
%   See test_overlay_brain.m
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist('region_masks', 'var') || ~iscell(region_masks)
    region_masks = {NaN};
end

if ~exist('alpha_val', 'var')
    alpha_val = 1;
end

if ~exist('doblackbackground', 'var')
    doblackbackground = 1;
end

if ~exist('colors2use', 'var') || ~iscell(colors2use)
    colors2use = [];
end

if ~exist('outerpadding', 'var')
    outerpadding = {[9,9], [9,10]};
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
padding = 8;
brain_im4D = combine_brains(brain_im, slice, brain_mask, padding, outerpadding);

if ~isnan(region_masks{1})
    for I = 1:length(region_masks)
        if (~isequal(size(region_masks{I}), [91,109,91])) && (~isequal(size(region_masks{I}), [182,218,182])) 
            region_masks{I} = index2mask(region_masks{I});
        elseif ~isequal(size(region_masks{I}), [182,218,182])
            if upsample
                region_masks{I} = imresize3(region_masks{I}, 2);
            end
        end
        region_masks{I} = combine_brains(region_masks{I}, slice, brain_mask, padding, outerpadding);
    end
end
% bounds = mask_bounds( brain_mask, padding );
% bounds = {1:91,1:109,1:91};

if applybrainmask
    brain_mask4D = combine_brains(brain_mask, slice, brain_mask, padding, outerpadding);
else
    brain_mask4D = ones(size(brain_im4D));
end

rotate = 1;
if any(isnan(underim(:)))
    brain_im_bw = ones([size(brain_im4D), 3]);
    brain_im_bw = squeeze(brain_im_bw.*brain_im4D/max(brain_im4D(:)));
    imagesc(brain_im_bw);
    hold on
    underim4D = combine_brains(underim, slice, brain_mask, padding, outerpadding);
    im1 = viewdata(underim4D, brain_mask4D, region_masks, colors2use, rotate, [], alpha_val);
    if max(underim4D(:)) > min(underim4D(:))
        caxis([min(underim4D(:)), max(underim4D(:))])
    end
else
    im1 = viewdata(brain_im4D, brain_mask4D, region_masks, colors2use, rotate, [], alpha_val);
    colormap('gray')
end

% axes('Units', 'normalized', 'Position', [0 0 1 1])
fullscreen;
ax = gca;

if doblackbackground
    set(gcf, 'Color', 'black');
end
set(gcf, 'Menubar', 'none')
set(gca, 'Position', [0,0,1,1])
axis image

end

