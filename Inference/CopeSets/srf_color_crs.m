function color_map = srf_color_crs( srf, lower_band, upper_band, xbar, c, posneg, colorscheme, usecontour )
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
if ~exist( 'posneg', 'var' )
   % Default value
   posneg = 1;
end

if ~exist( 'usecontour', 'var' )
   % Default value
   usecontour = 1;
end

if ~exist( 'colorscheme', 'var' )
   % Default value
   colorscheme = 'bowring';
end

%%  Main Function Loop
%--------------------------------------------------------------------------
if posneg == 1
    [ lower_set, upper_set, contour, yellow_set ] = srf_scb2cope( srf, lower_band, upper_band, xbar, c );
elseif posneg == -1
    [ upper_set, lower_set, contour, yellow_set] = srf_scb2cope( srf, -lower_band, -upper_band, -xbar, c );
end

if usecontour
    sets = {lower_set, contour, upper_set};
else
    sets = {lower_set, yellow_set, upper_set};
end

if strcmp(colorscheme, 'blue')
    colours = {[0.5,0.5, 1], [0,1,1], [0,0,0.9]};
elseif strcmp(colorscheme, 'red')
    colours = {[0.5,0.5, 1], [0,1,1], [0,0,0.9]};
else
    colours = {[0,0,1], [1,1,0], [1,0,0]};
end

color_map = srf_colour(srf, sets, colours);

% srfplot(srf, color_map)

end

