function [ out ] = srf_cope_display( srf, lower_set, upper_set, muhat, c )
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
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
%lower_set = upper_cb > c;
%upper_set = lower_cb > c;
yellow_set = muhat > c;
color_map = zeros(length(muhat), 3); % Generates random RGB colors
color_map(logical(lower_set.*(1-upper_set)), 3) = 1;
color_map(upper_set, 1) = 1;
color_map(logical(1-lower_set), :) = ones(sum((1-lower_set)),3)*0.7;

color_map(logical(yellow_set.*(1-upper_set)),1) = 1;
color_map(logical(yellow_set.*(1-upper_set)),2) = 1;
color_map(logical(yellow_set.*(1-upper_set)),3) = 0;

color_map(isnan(muhat), :) = ones(sum(isnan(muhat)),3);

srfplot(srf, color_map, 0, 0.05, 1)

end

