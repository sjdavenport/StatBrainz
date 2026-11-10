function [ im ] = viewthresh( map, frontgroundcolor, backgroundcolor )
% VIEWTHRESH Visualizes a thresholded map with specified foreground and background colors.
%
% This function creates an RGB image from a thresholded map by assigning 
% specified colors to the foreground and background. The result is displayed 
% using the imagesc function.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory:
%   map              - A 2D binary matrix (logical array) where 1 indicates 
%                      foreground pixels and 0 indicates background pixels.
%   frontgroundcolor - A 1x3 vector specifying the RGB color for the foreground.
%
% Optional:
%   backgroundcolor  - A 1x3 vector specifying the RGB color for the background.
%                      Default value is [0, 0, 0] (black).
%
% OUTPUT
%   im - A 3D matrix representing the RGB image where the foreground and 
%        background are colored according to the specified colors.
%--------------------------------------------------------------------------
% EXAMPLES
% dim = [50,50]; radii = 5;
% signal = square_signal(dim, radii )
% imagesc(signal)
% signal = square_signal(dim, 4, {[25,20], [25,30]} )
% viewthresh(signal, [1,0,0])
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'backgroundcolor', 'var' )
   % Default value
   backgroundcolor = [0,0,0];
end

%%  Main Function Loop
%--------------------------------------------------------------------------
im = zeros([size(map), 3]);
im(:,:,1) = map*frontgroundcolor(1);
im(:,:,2) = map*frontgroundcolor(2);
im(:,:,3) = map*frontgroundcolor(3);
im(:,:,1) = im(:,:,1) + (1-map)*backgroundcolor(1);
im(:,:,2) = im(:,:,2) + (1-map)*backgroundcolor(2);
im(:,:,3) = im(:,:,3) + (1-map)*backgroundcolor(3);
imagesc(im)
axis off

end

