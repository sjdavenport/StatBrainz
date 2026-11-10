function color_map = srf_blue_crs( srf, lower_band, upper_band, xbar, c )
% SRF_BLUE_CRS computes a blue colour map for surface cope set display.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  srf         the surface structure
%  lower_band  lower confidence band of size equal to the number of vertices
%  upper_band  upper confidence band of size equal to the number of vertices
%  xbar        estimated mean field of size equal to the number of vertices
%  c           the threshold at which to generate the cope set
%--------------------------------------------------------------------------
% OUTPUT
%  color_map   an nvertices-by-3 RGB colour map for the surface
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

