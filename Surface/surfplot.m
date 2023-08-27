function surfplot( path4gifti, surface_data, seeback, edgealpha, view_vec )
% SURFPLOT
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% See test_surfplot.m
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'seeback', 'var' )
   % Default value
   seeback = 0;
end

if ~exist( 'view_vec', 'var' )
   % Default value
   if seeback == 0
       view_vec = [-89, 16];
   else
       view_vec = [89,-16];
   end
end

if ~exist( 'edgealpha', 'var' )
   % Default value
   edgealpha = 0.05;
end

if nargin < 2
   % Default value
   use_surface_data = 0;
   warning('surface_data not included - plotting the empty mesh')
else
   use_surface_data = 1;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
g = gifti(path4gifti);
vertices = double(g.vertices);
X = vertices(:,1);
Y = vertices(:,2);
Z = vertices(:,3);
if use_surface_data == 1
    trisurf(double(g.faces), X, Y, Z,'FaceColor', 'interp', ...
        'FaceVertexCData', surface_data, 'EdgeAlpha', edgealpha);
else
    trisurf(double(g.faces), X, Y, Z,'FaceColor', 'None', 'EdgeAlpha', edgealpha);
end
xlim([min(X)-1, max(X)+1])
ylim([min(Y)-1, max(Y)+1])
zlim([min(Z)-1, max(Z)+1])
axis off

view(view_vec)

end

