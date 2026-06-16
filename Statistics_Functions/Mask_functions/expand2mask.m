function [ out ] = expand2MNI( im, mask, padding )
% EXPAND2MNI( im, mask, padding ) places a sub-image im back into a full
% [91,109] MNI-sized image at the bounds defined by mask.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  im      a 2D numeric array to expand into the MNI template space.
%  mask    a 3D (or 2D) binary mask defining the bounds of im.
% Optional
%  padding   additional padding (in voxels) passed to mask_bounds.
%            Default is 0.
%--------------------------------------------------------------------------
% OUTPUT
%  out   a [91,109] image with im inserted at the appropriate bounds.

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

out = zeros([91,109]);
out(bounds{:}) = im;

end

