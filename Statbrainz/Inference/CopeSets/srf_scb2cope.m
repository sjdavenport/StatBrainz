function [ lower_set, upper_set, contour, yellow_set ] = srf_scb2cope( srf, lower_band_im, upper_band_im, muhat, c )
% SRF_SCB2COPE converts simultaneous confidence bands to cope sets on a surface.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  srf           the surface structure (or struct with fields lh/rh for bilateral)
%  lower_band_im lower confidence band of size equal to the number of vertices
%                (or struct with lh/rh)
%  upper_band_im upper confidence band of size equal to the number of vertices
%                (or struct with lh/rh)
%  muhat         estimated mean field over vertices (or struct with lh/rh)
%  c             the threshold at which to generate the cope set
%--------------------------------------------------------------------------
% OUTPUT
%  lower_set   lower cope set (0/1 array over vertices, or struct with lh/rh)
%  upper_set   upper cope set (0/1 array over vertices, or struct with lh/rh)
%  contour     contour of the excursion set {muhat > c} on the surface
%  yellow_set  excursion set {muhat > c} (0/1 array over vertices, or struct with lh/rh)
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
if isfield(srf, 'lh') && isfield(srf, 'rh')
    for hemi = {'lh', 'rh'}
        h = hemi{1};
        lower_set.(h) = upper_band_im.(h) > c;
        upper_set.(h) = lower_band_im.(h) > c;
        % muhat.(h) = muhat.(h).*zero2nan(mask.(h));
    end
    contour.lh = srf_contour(srf, muhat.lh > c) > 0;
    contour.rh = srf_contour(srf, muhat.rh > c) > 0;
    yellow_set.lh = muhat.lh > c;
    yellow_set.rh = muhat.rh > c;
else
    lower_set = upper_band_im > c;
    upper_set = lower_band_im > c;
    % lower_set = lower_set.*mask;
    % upper_set = upper_set.*mask;
    % muhat = muhat.*zero2nan(mask);
    contour = srf_contour(srf, muhat > c) > 0;
    yellow_set = muhat > c;
end

% srf_cope_display( srf, lower_set, upper_set, muhat, c, view_vec, use_contour, redblue, dointerp )

% color_map = srf_colour(srf, {lower_set, upper_set, contour}, {[0,0,1], [1,0,0], [0,1,1]});

% srfplot(srf, color_map, view_vec)
% srfplot(srf, color_map);

end

