function ax = overlay_brainslice( slice, region_masks, colors2use, alpha_val, underim, upsample, rotate, applybrainmask, doblackbackground, padding)
% overlay_brain - Overlay region masks on a brain slice image.
%
%   overlay_brain(slice, padding, region_masks, colors2use, alpha_val, rotate)
%   overlays region masks on a brain slice image. It takes the following
%   input arguments:
%
% Mandatory Inputs:
%   - slice: A 3-element numeric array specifying the slice coordinates
%            either [x,0,0] or [0,y,0] or [0,0,z]
%
% Optional Inputs:
%   - padding: An optional numeric value specifying the padding around
%              the region masks. Default is 2.
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
% slice = 45;
% overlay_brainslice([0, 0, slice], {MNIbrain > 0.8}, 'red', 0.6)
%
% MNIbrain = imgload('MNIbrain.nii.gz');
% MNIbrain = MNIbrain/max(MNIbrain(:));
% slice = 45;
% overlay_brainslice([0, 0, slice], {NaN}, {NaN}, 1, zero2nan(MNIbrain > 0.8), 1 )
%
% MNIbrain = imgload('MNIbrain.nii.gz');
% MNIbrain = MNIbrain/max(MNIbrain(:));
% slice = 45;
% overlay_brainslice([0, 0, slice], {MNIbrain > 0.8}, {'red'}, 1, [], 1 )
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist('region_masks', 'var')
    region_masks = {NaN};
end

if isnumeric(region_masks)
    region_masks = {NaN};
end

if ~exist('alpha_val', 'var')
    alpha_val = 1;
end

if ~exist('colors2use', 'var')
    colors2use = [];
end

if ~exist('padding', 'var')
    padding = 10;
end

if ~exist('underim', 'var')
    underim = [];
end

index_loc = find(slice);
if ~exist('rotate', 'var')
    rotate = 4;
end

if ~exist('applybrainmask', 'var')
    applybrainmask = 1;
end

if ~exist('upsample', 'var')
    upsample = 0;
end

if ~exist('doblackbackground', 'var')
    doblackbackground = 1;
end

if upsample
    slice = slice*2;
    if isequal(size(underim), [91,109,91])
        underim = doubleim(underim);
    end
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
index = repmat({':'}, 1, 3);
index{index_loc} = slice(index_loc);

if ~isequal(NaN, region_masks{1}) && length(size(region_masks{1})) ~= 2
    for I = 1:length(region_masks)
        if upsample && isequal(size(region_masks{I}), [91,109,91])
            region_masks{I} = doubleim(region_masks{I});
        end
       region_masks{I} = squeeze(region_masks{I}(index{:}));
    end

end

bounds = mask_bounds( brain_mask, padding );
% bounds = {1:91,1:109,1:91};
other_indices = setdiff(1:3,index_loc);
bounds = bounds(other_indices);

brain_im2D = squeeze(brain_im(index{:}));
if applybrainmask
    brain_mask2D = squeeze(brain_mask(index{:}));
else
    brain_mask2D = ones(size(squeeze(brain_mask(index{:}))));
end

% if rotate == 2
%     imagesc(brain_im_bw')
% %     data = data';
% elseif rotate == 3
%     imagesc(flipud(brain_im_bw'))
% %     data = flipud(data);
% elseif rotate == 4
%     imagesc(flipud(brain_im_bw'));
% %     data = flipud(data');
% else
% end

if any(isnan(underim(:)))
    brain_im2D_bounded = brain_im2D(bounds{:});
    if rotate == 2
        brain_im2D_bounded = brain_im2D_bounded';
    elseif rotate == 3
        brain_im2D_bounded = flipud(brain_im2D_bounded);
    elseif rotate == 4
        brain_im2D_bounded = flipud(brain_im2D_bounded');
    end
    
    brain_im_bw = ones([size(brain_im2D_bounded), 3]);
    brain_im_bw = squeeze(brain_im_bw.*brain_im2D_bounded/max(brain_im2D_bounded(:)));
    imagesc(brain_im_bw);
    hold on
    underim2D = squeeze(underim(index{:}));
    im1 = viewdata(underim2D, brain_mask2D, region_masks, colors2use, rotate, bounds, alpha_val);
    if max(underim2D(:)) > min(underim2D(:))
        caxis([min(underim2D(:)), max(underim2D(:))])
    end
else
    im1 = viewdata(brain_im2D, brain_mask2D, region_masks, colors2use, rotate, bounds, alpha_val);
    colormap('gray')
end

axis image
% fullscreen;
ax = gca;
set(gcf, 'Menubar', 'none')
set(gca, 'Position', [0,0,1,1])
if doblackbackground
    set(gcf, 'Color', 'black');
end

end

