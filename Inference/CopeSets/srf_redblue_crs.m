function color_map = srf_redblue_crs( srf, lower_band, upper_band, xbar, c, addlower )
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
[ lower_set, upper_set, contour ] = srf_scb2cope( srf, lower_band, upper_band, xbar, c );
[ upper_set2, lower_set2, contour2 ] = srf_scb2cope( srf, -lower_band, -upper_band, -xbar, c );

if addlower
    lower_intersection = lower_set.*lower_set2 >0;
    lower_just1 = lower_set - lower_intersection >0;
    lower_just2 = lower_set2 - lower_intersection >0;
    %
    % sets = {lower_intersection, lower_just1, lower_just2, upper_set, upper_set2, contour, contour2};
    % colours = {[0.5765    0.4392    0.6], [1,0.5,0.5], [0.5,0.5, 1], [0.9,0,0], [0,0,0.9], [1,1,0], [0,1,1]};
    sets = {lower_intersection, lower_just1, lower_just2, upper_set, upper_set2};
    colours = {[0.5765    0.4392    0.6], [1,0.5,0.5], [0.5,0.5, 1], [0.9,0,0], [0,0,0.9]};
else
    sets = {upper_set, upper_set2};
    colours = {[0.9,0,0], [0,0,0.9]};
end

color_map = srf_colour(srf, sets, colours);

% srfplot(srf, color_map)

end

