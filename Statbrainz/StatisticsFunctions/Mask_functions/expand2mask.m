function [ out ] = expand2mask( im, mask, padding )
% EXPAND2MASK( im, mask, padding ) places a sub-image im back into a full
% image of the size of mask, at the bounds of mask. This is the inverse of
% cropping an image to the bounds of a mask with mask_bounds.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  im        a D-dimensional numeric array with the size of the bounds of
%            mask, e.g. im = full_im(bounds{:}) where
%            bounds = mask_bounds(mask, padding).
%  mask      a binary mask that defines the bounds of im. If mask has more
%            dimensions than im, only the first D dimensions of mask are
%            used (e.g. a 2D im and a 3D mask give a 2D output).
% Optional
%  padding   additional padding (in voxels) passed to mask_bounds.
%            Default is 0.
%--------------------------------------------------------------------------
% OUTPUT
%  out       an array with the size of the first D dimensions of mask, that
%            is im inside the bounds and 0 elsewhere.
%--------------------------------------------------------------------------
% Copyright (C) - 2025 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'padding', 'var' )
   % Default value
   padding = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
bounds = mask_bounds(mask,padding);
D = length(size(im));
if length(bounds) == 3 && D == 2
    bounds = bounds(1:2);
end

s_mask = size(mask);
out = zeros(s_mask(1:length(bounds)));
out(bounds{:}) = im;

end
