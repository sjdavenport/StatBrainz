function [ out ] = overlay_brain( slice, padding, region_masks, colors2use, alpha_val, rotate)
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% 
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

index_loc = find(slice);
if ~exist('rotate', 'var')
    rotate = 4;
%     if index_loc == 2 
%         rotate = 4;
%     else
%         rotate = 2;
%     end
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

viewdata(brain_im2D, brain_mask2D, region_masks, colors2use, rotate, bounds, alpha_val); 
colormap('gray')

end

