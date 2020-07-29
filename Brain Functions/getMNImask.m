function [ MNImask, bounds ] = getMNImask
% getMNImask obtains the smaller MNImask and the bounds for obtaining it
% from the larger nifti image
%--------------------------------------------------------------------------
% OUTPUT
% MNImask   a 72x90x77 array which is the smallest box that correctly
%           contains the MNImask
%--------------------------------------------------------------------------
% EXAMPLES
% [ MNImask, bounds ] = getMNImask;
% imagesc(MNImask(:,:,37))
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

% Load in the MNImask from the nifti file
MNImask = imgload('MNImask');

% Obtain the bounds of the MNImask
bounds = mask_bounds( MNImask );

% Shrink to match the box bounds
MNImask = logical(MNImask(bounds{:}));

end

