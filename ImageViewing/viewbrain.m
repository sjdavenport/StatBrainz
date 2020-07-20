function [ clim ] = viewbrain( brain, plane, mask, CB, clim )
% NEWFUN serves as a function template.
%--------------------------------------------------------------------------
% ARGUMENTS
% 
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% AUTHOR: Samuel J. Davenport
if nargin < 3
    if isequal(size(brain), [91,109,91])
        mask = zero2nan(imgload('MNImask'));
    else
        mask = ones(size(brain));
    end
end
if nargin < 4
    CB = 0;
end

if plane(1) > 0
    slice = fliplr(squeeze(brain(plane(1), :,:)))';
    slice_mask = fliplr(squeeze(mask(plane(1), :,:)))';
elseif plane(2) > 0
%     slice = fliplr(squeeze(brain(:,plane(2),:).*mask(:,plane(2),:)))';
    slice = fliplr(squeeze(brain(:,plane(2),:)))';
    slice_mask = fliplr(squeeze(mask(:,plane(2),:)))';
elseif plane(3) > 0
%     slice = fliplr(brain(:,:, plane(3)).*mask(:,:, plane(3)))';
    slice = fliplr(brain(:,:, plane(3)))';
    slice_mask = fliplr(mask(:,:, plane(3)))';
end

slice_mask = nan2zero(slice_mask);
color = zeros([size(slice_mask), 3]);
if nargin < 5
    clim = [min(slice(:)), max(slice(:))];
end
imagesc(slice, clim)
hold on
im2 = imagesc(color);
set(im2,'AlphaData',1-slice_mask);

if CB
    colorbar
end

end

