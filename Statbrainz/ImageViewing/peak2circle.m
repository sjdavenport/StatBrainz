function [ circlemask ] = peak2circle( point_coordinates )
% PEAK2CIRCLE creates a hollow cubic shell mask centered at a given coordinate
% in a 182x218x182 volume (1mm MNI space scaled by 2).
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  point_coordinates  a 1x3 vector [x, y, z] specifying the center point
%                     in standard (91x109x91) voxel coordinates
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% circlemask   a logical 182x218x182 array with a hollow shell around the
%              specified point
%--------------------------------------------------------------------------
% EXAMPLES
% [ circlemask ] = peak2circle( [49,50,49] );
% imagesc(circlemask(:,:,98))
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
circlemask = zeros([182,218,182]);
point_coordinates2 = 2*point_coordinates;
circlemask((point_coordinates2(1)-2:point_coordinates2(1)+2), (point_coordinates2(2)-2:point_coordinates2(2)+2), (point_coordinates2(3)-2:point_coordinates2(3)+2)) = 1;
circlemask((point_coordinates2(1)-1:point_coordinates2(1)+1), (point_coordinates2(2)-1:point_coordinates2(2)+1), (point_coordinates2(3)-1:point_coordinates2(3)+1)) = 0;
circlemask = logical(circlemask);

end

