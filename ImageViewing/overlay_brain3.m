function overlay_brain3( slice, padding, region_masks, colors2use, alpha_val, underim, rotate, applybrainmask, upsample)
% overlay_brain3 - plots images of brains through a given slice
%
%   overlay_brain3(slice, padding, region_masks, colors2use, alpha_val, rotate)
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
% EXAMPLES
% 
%--------------------------------------------------------------------------
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

if ~exist('padding', 'var')
    padding = 2;
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
subplot(1,3,1)
overlay_brain( [0,0,slice(3)], padding, region_masks, colors2use, alpha_val, underim, rotate, applybrainmask, upsample)
subplot(1,3,2)
overlay_brain( [0,slice(2),0], 6, padding, region_masks, colors2use, alpha_val, underim, rotate, applybrainmask, upsample)
subplot(1,3,3)
overlay_brain( [slice(1),0,0], 6, padding, region_masks, colors2use, alpha_val, underim, rotate, applybrainmask, upsample)

end

