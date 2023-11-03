function [ out ] = pan3( img, point, rotate )
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

