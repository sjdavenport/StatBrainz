function smooth_data = smooth_surface(srf, data, FWHM, metric, niters )
% SMOOTH_SURFACE Smooths data on the surface using nearest neighbor smoothing.
%
%   smooth_data = smooth_surface(srf, data, FWHM, metric, niters) smoothes
%   data on the surface 'srf' using nearest neighbor smoothing with the
%   specified full width at half maximum (FWHM), data, metric, and number
%   of iterations (niters).
%--------------------------------------------------------------------------
% ARGUMENTS
%   Mandatory
%       srf       - Surface structure.
%       data      - Input surface data to be smoothed.
%       FWHM      - Full width at half maximum for smoothing.
%   Optional
%       metric    - Metric for smoothing (default: 'ones').
%       niters    - Number of iterations for smoothing (default: determined by FWHM).
%--------------------------------------------------------------------------
% OUTPUT
%   smooth_data - Smoothed surface data.
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
if ~exist('metric', 'var')
    metric = 'ones';
end

%%  Main Function Loop
%--------------------------------------------------------------------------
lhrh = 0;
clear smooth_data
if ~isstruct(srf)
    g = gifti(srf);
    clear srf
    srf.faces = g.faces;
    srf.vertices = g.vertices;
    srf.data = data;
else
    if isfield(srf, 'lh')
        smooth_data.lh = smooth_surface(srf.lh, data.lh, FWHM);
        lhrh = 1;
    end
    if isfield(srf, 'rh')
        smooth_data.rh = smooth_surface(srf.rh, data.rh, FWHM);
        lhrh = 1;
    end
end


if lhrh == 0
    % if ~isfield(surface, 'data') && (nargin == 4)
    %     surface.data = data;
    % end
    % surface.data = SurfStatSmooth( surface.data', surface, FWHM )';
    if ~exist('niters', 'var')
        niters = srf_fwhm2niters(FWHM, srf);
    end
    smooth_data = SurfStatSmooth( srf, data', FWHM, metric, niters)';
end

end

