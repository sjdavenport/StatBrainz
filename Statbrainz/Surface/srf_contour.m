function [ inner_contour, outer_contour ] = srf_contour( srf, mask, adjacent_set_mask )
% SRF_CONTOUR Computes the inner and outer contours of a mask on a surface.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  srf              surface structure (or bilateral struct with .lh/.rh)
%  mask             logical mask vector over vertices
% Optional
%  adjacent_set_mask  logical mask; restricts contour to vertices adjacent
%                     to this set
%--------------------------------------------------------------------------
% OUTPUT
%  inner_contour    logical mask of vertices on the inner boundary of mask
%  outer_contour    logical mask of vertices on the outer boundary of mask
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

%%  Main Function Loop
%--------------------------------------------------------------------------
if isfield(srf, 'lh') && isfield(srf, 'rh')
    [inner_contour.lh, outer_contour.lh] = srf_contour( srf.lh, mask.lh );
    [inner_contour.rh, outer_contour.rh] = srf_contour( srf.rh, mask.rh );
else
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

end

