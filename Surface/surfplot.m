function surfplot( path4gifti, surface_data, view_vec )
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
if ~exist( 'view_vec', 'var' )
   % Default value
   view_vec = [-89, 16];
end

%%  Main Function Loop
%--------------------------------------------------------------------------
g = gifti(path4gifti);
vertices = double(g.vertices);
X = vertices(:,1);
Y = vertices(:,2);
Z = vertices(:,3);
trisurf(double(g.faces), X, Y, Z,'EdgeAlpha', 0.05);
view(view_vec)
xlim([min(X)-1, max(X)+1])
ylim([min(Y)-1, max(Y)+1])
zlim([min(Z)-1, max(Z)+1])
axis off

end

