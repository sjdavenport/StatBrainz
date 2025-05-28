function data = srf_noise( srf, FWHM, nsubj, metric, mask )
% SRF_NOISE Generates surface noise data.
%   data = srf_noise(srf, FWHM, metric) generates surface noise data on the
%   given surface structure 'srf' with specified full width at half maximum
%   (FWHM) and metric.
%--------------------------------------------------------------------------
% ARGUMENTS
%   Mandatory
%       srf       - Surface structure.
%   Optional
%       FWHM      - Full width at half maximum for smoothing (default: 0).
%       metric    - Metric for smoothing (default: 'ones').
%--------------------------------------------------------------------------
% OUTPUT
%   data         - Generated surface noise data containing fields for the
%                   left and right hemisphere if they are provided in srf.
%--------------------------------------------------------------------------
% EXAMPLES
% See test_srf_noise.m
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
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

if ~exist( 'nsubj', 'var' )
   % Default value
   nsubj = 1;
end

if ~exist( 'mask', 'var' )
    usemask = 0;
else
    usemask = 1;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
lrh = 0;
clear data
if isfield(srf, 'lh')
    if usemask
        data.lh = srf_noise( srf.lh, FWHM, nsubj, metric, mask.lh );
    else
        data.lh = srf_noise( srf.lh, FWHM, nsubj, metric );
    end
    lrh = 1;
end
if isfield(srf, 'rh')
    if usemask
        data.rh = srf_noise( srf.rh, FWHM, nsubj, metric, mask.rh );
    else
        data.rh = srf_noise( srf.rh, FWHM, nsubj, metric );
    end
    lrh = 1;
end

if lrh == 0     
    data = randn(srf.nvertices, nsubj);
    if usemask 
        data = data.*mask;
    end
    if FWHM > 0 
       data = smooth_surface(srf, data, FWHM, metric);
       if usemask
          smoothed_mask = smooth_surface(srf, mask, FWHM, metric);
          data = data./smoothed_mask;
       end
    end
end

end

