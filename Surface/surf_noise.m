function data = surf_noise( srf, FWHM, metric )
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
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'metric', 'var' )
   % Default value
   metric = 'ones';
end

if ~exist( 'FWHM', 'var' )
   % Default value
   FWHM = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
lrh = 0;
clear data
if isfield(srf, 'lh')
    data.lh = surf_noise( srf.lh, FWHM, metric );
    lrh = 1;
end
if isfield(srf, 'rh')
    data.rh = surf_noise( srf.rh, FWHM, metric );
    lrh = 1;
end

if lrh == 0     
    data = randn(srf.nvertices, 1);
    if FWHM > 0 
        data = smooth_surface(srf, data, FWHM, metric);
    end
end

end

