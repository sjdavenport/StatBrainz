function [ inner_contour, outer_contour ] = srf_contour( srf, mask, adjacent_set_mask )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% % EXAMPLES
% srf = loadsrf('fs5', 'sphere')
% data = randn(srf.lh.nvertices,1);
% mask = smooth_surface(srf.lh, data, 20) > 0;
% [inner_contour, outer_contour] = srf_contour(srf.lh, mask);
% subplot(1,3,1)
% srfplot(srf.lh, mask); title('Original Mask', 'color', 'white')
% subplot(1,3,2)
% srfplot(srf.lh, inner_contour); title('Inner Contour', 'color', 'white')
% subplot(1,3,3)
% srfplot(srf.lh, outer_contour); title('Outer Contour', 'color', 'white')
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
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
dilated_mask = srf_dilate_mask(srf, mask, 1);
shrunk_mask = srf_dilate_mask(srf, mask, -1);
inner_contour = mask - shrunk_mask;
outer_contour = dilated_mask - mask;

if exist('adjacent_set_mask', 'var')
    adjacent_set_dilated = srf_dilate_mask(srf, adjacent_set_mask, 1);
    inner_contour = inner_contour.*adjacent_set_dilated;
    outer_contour = outer_contour.*adjacent_set_mask;
end

end

