function [ plane, clim ] = viewbrain( brain, plane, mask, padding, color_bar, clim )
% NEWFUN serves as a function template.
%--------------------------------------------------------------------------
% ARGUMENTS
% brain - a 3D matrix representing the brain volume
% plane - a 1x3 vector specifying which plane to view (0 indicates not 
%         viewing that plane)
% mask - a 3D matrix representing the mask to be applied on the brain 
%           volume (optional, default is an all ones matrix if brain is the
%           standard size, or an all zeros matrix if brain is not the standard size)
% padding - a scalar representing the amount of padding to be applied on the
%         mask and brain volume (optional, default is 0)
% color_bar - a binary value indicating whether to display a colorbar or not 
%            (optional, default is 0)
% clim - a 1x2 vector specifying the color limits of the brain volume 
%           (optional, default is the min and max of the brain volume)
%--------------------------------------------------------------------------
% OUTPUT
% plane - a 1x3 vector specifying which plane was viewed
% clim - a 1x2 vector specifying the color limits of the brain volume
%--------------------------------------------------------------------------
% EXAMPLES
% brain = imgload('fullmean');
% mask = imgload('MNImask')
% [plane, clim] = viewbrain(brain, [0,0,20], mask)
% [plane, clim] = viewbrain(brain, [0,0,20], mask, 10, 1, [0,1])
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------
if ~exist('mask', 'var')
    if isequal(size(brain), [91,109,91])
        mask = zero2nan(imgload('MNImask'));
    else
        mask = ones(size(brain));
    end
end

if ~exist('color_bar', 'var')
    color_bar = 0;
end

if ~exist('padding', 'var')
    padding = 0;
end
if padding > 0 
    mask = pad_vals(mask, padding);
    brain = pad_vals(brain, padding);
end
s_mask = size(mask);

plane_pos_loc = find(plane);
plane_addition = sbasis(plane_pos_loc, 3)';
plane = plane + plane_addition*padding;

if plane(1) > 0
    slice = fliplr(squeeze(brain(plane(1), :,:)))';
    slice_mask = fliplr(squeeze(mask(plane(1), :,:)))';
    gcf_position = s_mask(2:end);
elseif plane(2) > 0
%     slice = fliplr(squeeze(brain(:,plane(2),:).*mask(:,plane(2),:)))';
    slice = fliplr(squeeze(brain(:,plane(2),:)))';
    slice_mask = fliplr(squeeze(mask(:,plane(2),:)))';
    gcf_position = [s_mask(1), s_mask(2)];
elseif plane(3) > 0
%     slice = fliplr(brain(:,:, plane(3)).*mask(:,:, plane(3)))';
    slice = fliplr(brain(:,:, plane(3)))';
    slice_mask = fliplr(mask(:,:, plane(3)))';
    gcf_position = s_mask(1:2);
end
gcf_position = gcf_position*6;

slice_mask = nan2zero(slice_mask);
color = zeros([size(slice_mask), 3]);
if ~exist('clim', 'var')
    clim = [min(slice(:)), max(slice(:))];
end
imagesc(slice, clim)
hold on
im2 = imagesc(color);
set(im2,'AlphaData',1-slice_mask);

if color_bar
    colorbar
end
xticks([])
yticks([])

gcf_position = [200,30,gcf_position];
set(gcf, 'position', gcf_position)

waitforbuttonpress;
value = double(get(gcf,'CurrentCharacter'));

if value == 30
    plane = plane - padding*plane_addition;
    [plane, clim] = viewbrain( brain, plane + plane_addition, mask, 0, color_bar, clim );
elseif value == 31
    plane = plane - padding*plane_addition;
    [plane, clim] = viewbrain( brain, plane - plane_addition, mask, 0, color_bar, clim );
end

end

