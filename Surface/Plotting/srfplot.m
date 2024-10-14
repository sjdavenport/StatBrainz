function srfplot( srf, surface_data, view_vec, dointerp, edgealpha, dofullscreen, dolighting )
% SRFPLOT Plots surface data on a given surface.
%
%   srfplot(path4surf, surface_data, view_vec, dointerp, edgealpha)
%   plots the surface defined by 'path4surf' with optional surface data
%   'surface_data'. Various optional parameters can be specified.
%--------------------------------------------------------------------------
% ARGUMENTS
%   Mandatory
%       path4surf   - Path to the surface file or surface structure.
%   Optional
%       surface_data- Surface data to be plotted.
%       view_vec    - View vector for plotting (default: [-89, 16]).
%       dointerp    - Flag for surface interpolation (default: 0).
%       edgealpha   - Transparency of surface edges (default: 0.2).
%--------------------------------------------------------------------------
% OUTPUT
%   Plots the surface with optional surface data.
%--------------------------------------------------------------------------
% EXAMPLES
% See test_srfplot.m
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'dofullscreen', 'var' )
   % Default value
   dofullscreen = 1;
end

if ~exist( 'view_vec', 'var' ) || any(isnan(view_vec))
    if isfield(srf, 'hemi')
        view_vec = 'side';
    else
        view_vec = 'top';
    end
end

if ~exist( 'surface_data', 'var' )
   % Default value
   surface_data = [];
end

if isfield(srf, 'hemi')
    if strcmp(srf.hemi, 'rh')
        default_sideview = [90, 0];
        default_backsideview = [270, 0];
    else
        default_sideview = [270,0];
        default_backsideview = [90, 0];
    end
    if ischar(view_vec)
        if strcmp(view_vec, 'side')
            view_vec = default_sideview;
        elseif strcmp(view_vec, 'backside')
            view_vec = default_backsideview;
        end
    end
    if isequal(view_vec, 0)
        view_vec = default_sideview;
    elseif isequal(view_vec, 1)
        view_vec = default_backsideview;
    end
    if length(surface_data) == srf.nfaces
        dointerp = 0;
    end
end

if isequal(view_vec, 0)
    view_vec = 'top';
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
% if seeback == 2
%     subplot(1,2,1)
%     srfplot( srf, surface_data, 0, edgealpha, dointerp, view_vec, dofullscreen )
%     subplot(1,2,2)
%     srfplot( srf, surface_data, 1, edgealpha, dointerp, view_vec, dofullscreen )
%     return
% end

if isstruct(srf)
    g = srf;
    if isfield(srf, 'lh') && isfield(srf, 'rh')
        clear jointsrf
        jointsrf.vertices = [srf.lh.vertices; srf.rh.vertices];
        jointsrf.faces = [srf.lh.faces; (srf.rh.faces + srf.lh.nvertices) ];
        jointsrf.nfaces = size(jointsrf.faces, 1);
        jointsrf.nvertices = size(jointsrf.vertices, 1);

        srfplot(jointsrf, [surface_data.lh; surface_data.rh], view_vec, dointerp, edgealpha, dofullscreen )
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
if dointerp == 1
    shading interp
elseif dointerp == 0
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

