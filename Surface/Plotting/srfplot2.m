function srfplot2( srf, surface_data, seeback, edgealpha, dointerp, view_vec, dofullscreen, dolighting )
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
% See test_srfplot.m
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

if ~exist( 'dofullscreen', 'var' )
   % Default value
   dofullscreen = 1;
end

default_frontview = [-90, 0];
% default_backview = [89,-16];
default_backview = [90,0];
if isfield(srf, 'hemi')
    if strcmp(srf.hemi, 'rh')
        seeback = 1 - seeback;
        default_backview = [90, 0]; % Actually front but see back is back to front
        default_frontview = [270, 0];
    end
end

using_default_view = 0;
if ~exist( 'view_vec', 'var' ) || any(isnan(view_vec))
   % Default value
   if seeback == 0
       view_vec = default_frontview;
       using_default_view = 1;
   else
       view_vec = default_backview;
   end
end

if ischar(view_vec)
    if strcmp(view_vec, 'top')
        view_vec = [0,90];
    elseif strcmp(view_vec, 'back')
        view_vec = [0,0];
    elseif strcmp(view_vec, 'front')
        view_vec = [-180, 0];
    elseif strcmp(view_vec, 'bottom')
        view_vec = [-180, -90];
    elseif strcmp(view_vec, 'left')
        view_vec = [-90, 0];
    elseif strcmp(view_vec, 'right')
        view_vec = [270, 0];
    end 
end

if ~exist( 'surface_data', 'var' )
   % Default value
   surface_data = [];
else
    if length(surface_data) == srf.nfaces
        dointerp = 0;
    end
end

if ~exist( 'dolighting', 'var' )
   % Default value
   dolighting = 1;
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
   dointerp = 1;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
if seeback == 2
    subplot(1,2,1)
    srfplot( srf, surface_data, 0, edgealpha, dointerp, view_vec, dofullscreen )
    subplot(1,2,2)
    srfplot( srf, surface_data, 1, edgealpha, dointerp, view_vec, dofullscreen )
    return
end

if isstruct(srf)
    g = srf;
    if isfield(srf, 'lh') && isfield(srf, 'rh')
        clear jointsrf
        jointsrf.vertices = [srf.lh.vertices; srf.rh.vertices];
        jointsrf.faces = [srf.lh.faces; (srf.rh.faces + srf.lh.nvertices) ];
        jointsrf.nfaces = size(jointsrf.faces, 1);
        jointsrf.nvertices = size(jointsrf.vertices, 1);

        srfplot(jointsrf, [surface_data.lh; surface_data.rh], seeback, edgealpha, dointerp, view_vec, dofullscreen )
        % srfplot(g.lh, surface_data.lh, seeback, edgealpha, dointerp, view_vec, dofullscreen, 1 )
        % hold on
        % srfplot(g.rh, surface_data.rh, seeback, edgealpha, dointerp, view_vec, dofullscreen, 0 )
        return
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

if dolighting
    camlight('headlight')
    lighting gouraud;
end
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

if use_surface_data
    set(gcf, 'Color', 'black');
end

if dofullscreen
    fullscreen;
end

end
% 
% if strcmp(srf(end-3:end), '.gii')
%     if ~exist('gifti', 'file')
%         error('You need to install the gifti matlab package, available here: https://github.com/gllmflndn/gifti in order to read gifti surface files. Once installed you must make sure its contents are available on the matlab path.')
%     end
%     g = gifti(srf);
% else
%     [vertices, faces] = read_fs_geometry(srf);
%     g.vertices = vertices;
%     g.faces = faces;
% end

