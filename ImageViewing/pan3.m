function [ out ] = pan3( img, point, rotate )
% PAN3 displays a 3D image in three orthogonal slices with a red overlay mask.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  img    a 3D matrix to display
%  point  a 1x3 vector [x, y, z] specifying the slice coordinates
% Optional
%  rotate a numeric value specifying the orientation of each slice. Default is 4.
%--------------------------------------------------------------------------
% OUTPUT
%  out    the output from the last overlay_brain call
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
if ~exist( 'rotate', 'var' )
   % Default value
   rotate = 4;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
subplot(1,3,1)
overlay_brain([point(1), 0, 0], 10, {squeeze(img(point(1), :,:))}, 'red', 0.6, 0, rotate, 0)
subplot(1,3,2)
overlay_brain([0, point(2), 0], 10, {squeeze(img(:,point(2),:))}, 'red', 0.6, 0, rotate, 0)
subplot(1,3,3)
overlay_brain([0, 0, point(3)], 10, {squeeze(img(:,:,point(3)))}, 'red', 0.6, 0, rotate, 0)
fullscreen
end

