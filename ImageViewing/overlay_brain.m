function overlay_brain( slice, padding, region_masks, colors2use, alpha_val, underim, rotate)
% overlay_brain - Overlay region masks on a brain slice image.
%
%   overlay_brain(slice, padding, region_masks, colors2use, alpha_val, rotate)
%   overlays region masks on a brain slice image. It takes the following
%   input arguments:
%
% Mandatory Inputs:
%   - slice: A 3-element numeric array specifying the slice coordinates
%            [x, y, z] where the overlay will be applied.
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
%   overlay_brain([0, 0, slice], 10, {WMsurviving_cluster_im(:,:,slice)}, 'red', 0.75, 4)
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------


%%  Check mandatory input and get important constants
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

if ~exist('padding', 'var')
    padding = 2;
end

if ~exist('underim', 'var')
    underim = [];
end

index_loc = find(slice);
if ~exist('rotate', 'var')
    rotate = 4;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
index = repmat({':'}, 1, 3);
index{index_loc} = slice(index_loc);
brain_im = imgload('MNIbrain.nii.gz');

brain_mask = imgload('MNImask') > 0;

bounds = mask_bounds( brain_mask, padding );
other_indices = setdiff(1:3,index_loc);
bounds = bounds(other_indices);

brain_im2D = squeeze(brain_im(index{:}));
brain_mask2D = squeeze(brain_mask(index{:}));


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
    viewdata(underim2D, brain_mask2D, region_masks, colors2use, rotate, bounds, alpha_val);
    caxis([min(underim2D(:)), max(underim2D(:))])
else
    viewdata(brain_im2D, brain_mask2D, region_masks, colors2use, rotate, bounds, alpha_val);
    colormap('gray')
end

axis image

end

