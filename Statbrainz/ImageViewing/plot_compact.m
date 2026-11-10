function plot_compact( n, m )
% PLOT_COMPACT creates a tiled layout with compact spacing.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  n   number of rows in the tiled layout
%  m   number of columns in the tiled layout
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% None.
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2025 - Samuel Davenport
%--------------------------------------------------------------------------
t = tiledlayout(n,m);
t.TileSpacing = 'compact';
t.Padding = 'compact';

end

