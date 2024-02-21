function smooth_data = smooth_surface(srf, data, FWHM, metric )
% smooth_surface( srf, FWHM, data ) smoothes data on the surface using
% nearest neighbour smoothing which corresponds to the FWHM.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  surface  a
%  FWHM     the FWHM with which to smooth
% Optional
%  data
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
    smooth_data = SurfStatSmooth( srf, data', FWHM, metric )';
end

end

