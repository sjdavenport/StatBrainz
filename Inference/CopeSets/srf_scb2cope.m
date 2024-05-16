function [ lower_set, upper_set, muhat ] = srf_scb2cope( srf, lower_band_im, upper_band_im, muhat, mask, c, view_vec, use_contour, redblue, dointerp )
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
if ~exist( 'dointerp', 'var' )
   % Default value
   dointerp = 1;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
if isfield(srf, 'lh') && isfield(srf, 'rh')
    for hemi = {'lh', 'rh'}
        h = hemi{1};
        lower_set.(h) = upper_band_im.(h) > c;
        upper_set.(h) = lower_band_im.(h) > c;
        muhat.(h) = muhat.(h).*zero2nan(mask.(h));
    end
else
    lower_set = upper_band_im > c;
    upper_set = lower_band_im > c;
    lower_set = lower_set.*mask;
    upper_set = upper_set.*mask;
    muhat = muhat.*zero2nan(mask);
end

srf_cope_display( srf, lower_set, upper_set, muhat, c, view_vec, use_contour, redblue, dointerp )

end

