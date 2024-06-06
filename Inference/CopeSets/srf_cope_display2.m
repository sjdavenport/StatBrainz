function [ out ] = srf_cope_display2( srf, lower_set, upper_set, muhat, c, view_vec, use_contour, dointerp )
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
if ~exist( 'view_vec', 'var' )
    % Default value
    view_vec = 0;
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
    color_map.lh = get_color_map(lower_set.lh, upper_set.lh, muhat.lh, c, use_contour, redblue, srf.lh);
    color_map.rh = get_color_map(lower_set.rh, upper_set.rh, muhat.rh, c, use_contour, redblue, srf.rh);
    % srfplot(srf, )
    srfplot(srf, color_map, view_vec, 0.05, dointerp, 'top', 0)
else
    color_map = get_color_map(lower_set, upper_set, muhat, c, use_contour, redblue, srf);
    % srfplot(srf, ones(size(color_map)), view_vec, dointerp, 0.05, 0)
    % hold on 
    srfplot(srf, color_map, view_vec, dointerp, 0.05, 0)
    % srfplot2(srf, color_map, seeback, 0.05, dointerp, NaN, 0)
    % srfplot2( srf, surface_data, seeback, edgealpha, dointerp, view_vec, dofullscreen, dolighting )
end

% axis image

end

function color_map = get_color_map(lower_set, upper_set, muhat, c, use_contour, redblue, srff)
yellow_set = muhat > c;
if use_contour
    yellow_set = srf_contour(srff, yellow_set);
end

color_map = zeros(length(muhat), 3); % Generates random RGB colors
color_map(upper_set, 1) = 1; %Red
color_map(upper_set, 2:3) = 0.2; %Red

color_map(logical(lower_set.*(1-upper_set)), 1) = 1; % Pink blue set
color_map(logical(lower_set.*(1-upper_set)), 2:3) = 0.5; %Red

color_map(logical(1-lower_set), :) = ones(sum((1-lower_set)),3)*0.7; %Grey

% if redblue
% 
% else
%     color_map(logical(lower_set.*(1-upper_set)), :) = ones(sum(lower_set.*(1-upper_set)),3)*0.7; %Grey
%     color_map(logical(1-lower_set), 3) = 1; %Blue
% end

color_map(logical(yellow_set.*(1-upper_set)),1) = 1;
color_map(logical(yellow_set.*(1-upper_set)),2) = 1;
color_map(logical(yellow_set.*(1-upper_set)),3) = 0;

color_map(isnan(muhat), :) = ones(sum(isnan(muhat)),3);
end
