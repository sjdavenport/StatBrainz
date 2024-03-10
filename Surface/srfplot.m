function srfplot( srf, surface_data, seeback, edgealpha, dointerp, view_vec )
% SRFPLOT Plots surface data on a given surface.
%
%   srfplot(path4surf, surface_data, seeback, edgealpha, dointerp, view_vec)
%   plots the surface defined by 'path4surf' with optional surface data
%   'surface_data'. Various optional parameters can be specified.
%--------------------------------------------------------------------------
% ARGUMENTS
%   Mandatory
%       path4surf   - Path to the surface file or surface structure.
%   Optional
%       surface_data- Surface data to be plotted.
%       seeback     - Flag for viewing from the back (default: 0).
%       edgealpha   - Transparency of surface edges (default: 0.2).
%       dointerp    - Flag for surface interpolation (default: 0).
%       view_vec    - View vector for plotting (default: [-89, 16]).
%--------------------------------------------------------------------------
% OUTPUT
%   Plots the surface with optional surface data.
%--------------------------------------------------------------------------
% EXAMPLES
% See test_surfplot.m
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

using_default_view = 0;
if ~exist( 'view_vec', 'var' )
   % Default value
   if seeback == 0
       view_vec = [-89, 16];
       using_default_view = 1;
   else
       view_vec = [89,-16];
   end
end

if ~exist( 'surface_data', 'var' )
   % Default value
   surface_data = [];
end

if ~exist( 'edgealpha', 'var' )
   % Default value
   if isempty(surface_data)
        edgealpha = 0.2;
   else
       edgealpha = 0.05;
   end
end

if ~exist( 'dointerp', 'var' )
   % Default value
   dointerp = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
if seeback == 2
    subplot(1,2,1)
    srfplot( srf, surface_data, 0, edgealpha, dointerp, view_vec )
    subplot(1,2,2)
    srfplot( srf, surface_data, 1, edgealpha, dointerp, view_vec )
    return
end

if isstruct(srf)
    g = srf;
    if isfield(srf, 'lh') && isfield(srf, 'rh')
        subplot(1,2,1)
        srfplot(g.lh, surface_data, seeback, edgealpha, docamlight, view_vec )
        subplot(1,2,2)
        if using_default_view == 1
            view_vec = [-84,-12];
        end
        srfplot(g.rh, surface_data, seeback, edgealpha, docamlight, view_vec )
        return
    end
else
    if strcmp(srf(end-3:end), '.gii')
        if ~exist('gifti', 'file')
            error('You need to install the gifti matlab package, available here: https://github.com/gllmflndn/gifti in order to read gifti surface files. Once installed you must make sure its contents are available on the matlab path.')
        end
        g = gifti(srf);
    else
        [vertices, faces] = read_fs_geometry(srf);
        g.vertices = vertices;
        g.faces = faces;
    end
end

if isempty(surface_data)
   % Default value
   use_surface_data = 0;
   warning('surface_data not included - plotting the empty mesh')
else
   use_surface_data = 1;
   surface_data = double(surface_data);
end


vertices = double(g.vertices);
X = vertices(:,1);
Y = vertices(:,2);
Z = vertices(:,3);
if use_surface_data == 1
    ptru = trisurf(double(g.faces), X, Y, Z, ...
            'FaceVertexCData', surface_data, 'EdgeAlpha', edgealpha);
    % if dointerp == 0
    %      ptru = trisurf(double(g.faces), X, Y, Z, ...
    %         'FaceVertexCData', surface_data, 'EdgeAlpha', edgealpha);
    % else
    %     ptru = trisurf(double(g.faces), X, Y, Z, 'FaceColor', 'interp', ...
    %         'FaceVertexCData', surface_data, 'EdgeAlpha', edgealpha);
    % end
else
    ptru = trisurf(double(g.faces), X, Y, Z,'FaceColor', 'None', 'EdgeAlpha', edgealpha);
end
xlim([min(X)-1, max(X)+1])
ylim([min(Y)-1, max(Y)+1])
zlim([min(Z)-1, max(Z)+1])
axis off

view(view_vec)

camlight('headlight')
lighting gouraud;
material dull;

%     camlight('right')
% light

% Do interpolation or not
if dointerp
    shading interp
else
    shading flat;
end

set(ptru,'AmbientStrength',0.5)
axis image
screen_size = get(0, 'ScreenSize');

% Set the figure position to cover the entire screen
set(gcf, 'Position', screen_size);

if use_surface_data
    set(gcf, 'Color', 'black');
end
% fullscreen
end

