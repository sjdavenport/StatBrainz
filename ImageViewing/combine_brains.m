function combined_im = combine_brains( brain_im, slice, brain_mask, padding, outerpad, use_bounds )
% Combine multiple brain images into a single composite image.
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
% MNIbrain = imgload('MNIbrain'); MNImask = imgload('MNImask');
% combined_im = combine_brains( MNIbrain, [30,40,30], MNImask, 8);
% imagesc(combined_im); fullscreen; axis off; axis image; 
%
% MNIbrain1mm = imgload('MNIbrain1mm.nii.gz');
% MNImask1mm = imgload('MNImask1mm.nii.gz') > 0;
% combined_im = combine_brains( MNIbrain1mm, [60,80,60], MNImask1mm, 8);
% imagesc(combined_im); fullscreen; axis off; axis image; colormap('gray')
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

if ~exist( 'outerpad', 'var' )
   % Default value
   outerpad = {0,0};
end

%%  Main Function Loop
%--------------------------------------------------------------------------
if isequal(size(brain_im),[182,218,182])
    scale = 2;
    padding = 2*padding;
else
    scale = 1;
end

if use_bounds == 0
    brain1 = flipud(squeeze(brain_im(slice(1),:,:))');
    brain2 = flipud(squeeze(brain_im(:,slice(2),:))');
    brain3 = flipud(squeeze(brain_im(:,:,slice(3)))');
    combined_im2 = [brain1, brain2];
    combined_im = zeros(scale*109, scale*291);
    combined_im(scale*(9:99),1:(scale*200)) = combined_im2;
    combined_im(:, scale*(201:291)) = brain3;
    if outerpad > 0
        combined_im = pad_im(combined_im, outerpad);
    end
    return
end

bounds = mask_bounds(brain_mask); 

% Adjust the slice to account for the bounds
for I = 1:3
    slice(I) = slice(I) - bounds{I}(1) + 1;
end
brain_im = brain_im(bounds{:});
brain1 = flipud(squeeze(brain_im(slice(1),:,:))');
brain2 = flipud(squeeze(brain_im(:,slice(2),:))');
brain3 = flipud(squeeze(brain_im(:,:,slice(3)))');
% combined_im2 = [brain1, zeros(size(brain1, 2), padding), brain2];
xlength = size(brain1,2) + size(brain2,2) + size(brain3,2) + 2*padding;
xlength2 = size(brain1,2) + size(brain2,2) + padding;
xlength1 = size(brain1,2);
combined_im = zeros(size(brain3,1), xlength);
ystart = floor((size(brain3,1) -  size(brain1,1))/2) + 3;
combined_im(ystart:(ystart + size(brain1,1) - 1),1:xlength1) = brain1;
combined_im(ystart:(ystart + size(brain1,1) - 1),(xlength1+1+padding):xlength2) = brain2;
combined_im(:, (xlength2+1+padding):xlength) = brain3;

if ~isequal(outerpad{1}, 0) || ~isequal(outerpad{2}, 0)
    if isscalar(outerpad{1})
        outerpad{1} = repmat(outerpad{1}, 1, 2);
    end
    if isscalar(outerpad{2})
        outerpad{2} = repmat(outerpad{2}, 1, 2);
    end
    combined_im = pad_im(combined_im, outerpad{1}, outerpad{2});
end

end

