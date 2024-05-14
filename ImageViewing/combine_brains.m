function combined_im = combine_brains( brain_im, slice, brain_mask, padding, use_bounds )
% Combine multiple brain images into a single composite image.
%
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%   brain_im      - 3D matrix, containing the brain images.
%   slice         - 1x3 vector, specifying the slice indices to extract
%                   from the brain images along each dimension.
%   brain_mask    - Binary 3D matrix, representing the brain mask.
% Optional
%   padding       - Scalar, representing the padding width between brain
%                   images. Default is 5.
%   use_bounds    - Binary value indicating whether to use the provided
%                   brain mask bounds to crop the images. Default is 1.
%--------------------------------------------------------------------------
% OUTPUT
%   combined_im   - Combined brain image.
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'use_bounds', 'var' )
   % Default value
   use_bounds = 1;
end

if ~exist( 'padding', 'var' )
   % Default value
   padding = 5;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
if use_bounds == 0
    brain1 = flipud(squeeze(brain_im(slice(1),:,:))');
    brain2 = flipud(squeeze(brain_im(:,slice(2),:))');
    brain3 = flipud(squeeze(brain_im(:,:,slice(3)))');
    combined_im2 = [brain1, brain2];
    combined_im = zeros(109, 291);
    combined_im(9:99,1:200) = combined_im2;
    combined_im(:, 201:291) = brain3;
    return
end

bounds = mask_bounds(brain_mask); 
brain_im = brain_im(bounds{:});
brain1 = flipud(squeeze(brain_im(slice(1),:,:))');
brain2 = flipud(squeeze(brain_im(:,slice(2),:))');
brain3 = flipud(squeeze(brain_im(:,:,slice(3)))');
% combined_im2 = [brain1, zeros(size(brain1, 2), padding), brain2];
xlength = size(brain1,2) + size(brain2,2) + size(brain3,2) + 2*padding;
xlength2 = size(brain1,2) + size(brain2,2) + padding;
xlength1 = size(brain1,2);
combined_im = zeros(size(brain3,1), xlength);
ystart = floor((size(brain3,1) -  size(brain1,1))/2);
combined_im(ystart:(ystart + size(brain1,1) - 1),1:xlength1) = brain1;
combined_im(ystart:(ystart + size(brain1,1) - 1),(xlength1+1+padding):xlength2) = brain2;
combined_im(:, (xlength2+1+padding):xlength) = brain3;



end

