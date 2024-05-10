function [ out ] = srf_scb2cope( srf, lower_band_im, upper_band_im, muhat, mask, c, seeback )
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
if ~exist( 'seeback', 'var' )
   % Default value
   seeback = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
lower_set = upper_band_im > c;
upper_set = lower_band_im > c;
lower_set = lower_set.*mask;
upper_set = upper_set.*mask;
muhat = muhat.*zero2nan(mask);

srf_cope_display( srf, lower_set, upper_set, muhat, c, seeback )

end

