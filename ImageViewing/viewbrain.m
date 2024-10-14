function ax = viewbrain( brain_im, slice, brain_mask )
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
% viewbrain(MNIbrain.*(MNIbrain> 0.8), [30,40,50]);
% viewbrain(MNIbrain.*(MNIbrain> 0.8)/max(MNIbrain(:)), [30,40,50]);
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

if ~exist('brain_mask', 'var')
    brain_mask = imgload('MNImask') > 0;
end

if ~exist('slice', 'var')
    slice = [30,40,50];
end

%%  Main Function Loop
%--------------------------------------------------------------------------
padding = 15;
brain_im4D = combine_brains(brain_im, slice, brain_mask, padding);
brain_mask4D = combine_brains(brain_mask, slice, brain_mask, padding);

rotate = 1;
im1 = viewdata(brain_im4D, brain_mask4D, {NaN}, [], rotate, []);
% colormap('gray')

% axes('Units', 'normalized', 'Position', [0 0 1 1])
axis image
fullscreen;
ax = gca;
set(gcf, 'Color', 'black');
set(gcf, 'Menubar', 'none')
set(gca, 'Position', [0,0,1,1])

end

