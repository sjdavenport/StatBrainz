function ax = viewbrain( brain_im, slice, brain_mask )
% viewbrain displays a brain image across three orthogonal views.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  brain_im    A 3D brain image matrix to display.
% Optional
%  slice       A 3-element numeric array [x, y, z] specifying the slice
%              coordinates. Default is [30,40,50].
%  brain_mask  A 3D binary mask defining the brain region. Default is the
%              MNImask.
%--------------------------------------------------------------------------
% OUTPUT
%  ax          handle to the current axes
%--------------------------------------------------------------------------
% Copyright (C) - 2025 - Samuel Davenport
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

