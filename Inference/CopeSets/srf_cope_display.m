function [ out ] = srf_cope_display( srf, lower_set, upper_set, muhat, c, seeback, use_contour, redblue, dointerp )
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

if ~exist( 'use_contour', 'var' )
    % Default value
    use_contour = 0;
end

if ~exist('dointerp','var')
    dointerp = 1;
end

if ~exist('redblue','var')
    redblue = 1;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
%lower_set = upper_cb > c;
%upper_set = lower_cb > c;
if isfield(srf, 'lh') && isfield(srf, 'rh')
    color_map.lh = get_color_map(lower_set.lh, upper_set.lh, muhat.lh, c, use_contour, redblue);
    color_map.rh = get_color_map(lower_set.rh, upper_set.rh, muhat.rh, c, use_contour, redblue);
    srfplot(srf, color_map, seeback, 0.05, dointerp, 'top', 0)
else
    color_map = get_color_map(lower_set, upper_set, muhat, c, use_contour, redblue);
    srfplot(srf, color_map, seeback, 0.05, dointerp, NaN, 0)
end

% axis image

end

function color_map = get_color_map(lower_set, upper_set, muhat, c, use_contour, redblue)
yellow_set = muhat > c;
if use_contour
    yellow_set = srf_contour(srf, yellow_set);
end

color_map = zeros(length(muhat), 3); % Generates random RGB colors
color_map(upper_set, 1) = 1; %Red

if redblue
    color_map(logical(lower_set.*(1-upper_set)), 3) = 1; %Blue
    color_map(logical(1-lower_set), :) = ones(sum((1-lower_set)),3)*0.7; %Grey
else
    color_map(logical(lower_set.*(1-upper_set)), :) = ones(sum(lower_set.*(1-upper_set)),3)*0.7; %Grey
    color_map(logical(1-lower_set), 3) = 1; %Blue
end

color_map(logical(yellow_set.*(1-upper_set)),1) = 1;
color_map(logical(yellow_set.*(1-upper_set)),2) = 1;
color_map(logical(yellow_set.*(1-upper_set)),3) = 0;

color_map(isnan(muhat), :) = ones(sum(isnan(muhat)),3);
end
