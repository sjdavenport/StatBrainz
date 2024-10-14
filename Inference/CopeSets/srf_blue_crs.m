function color_map = srf_blue_crs( srf, lower_band, upper_band, xbar, c )
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
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'addlower', 'var' )
   % Default value
   addlower = 1;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
% [ upper_set, lower_set, contour ] = srf_scb2cope( srf, -lower_band,
% -upper_band, -xbar, c ); % Equivalently
[ lower_set, upper_set, contour ] = srf_scb2cope( srf, -upper_band, -lower_band, -xbar, c );


sets = {lower_set, contour, upper_set};
colours = {[0.5,0.5, 1], [0,1,1], [0,0,0.9]};

color_map = srf_colour(srf, sets, colours);

% srfplot(srf, color_map)

end

