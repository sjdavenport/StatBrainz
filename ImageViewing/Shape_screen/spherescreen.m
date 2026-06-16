function spherescreen(docolorbar)
% SPHERESCREEN sets the current figure to a square position suitable for sphere plots.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%  docolorbar   0/1 whether to display a colorbar and adjust the figure
%               position to accommodate it. Default is 0.
%--------------------------------------------------------------------------
% OUTPUT
% None.
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'docolorbar', 'var' )
   % Default value
   docolorbar = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
% set(gcf, 'position', [0,0,1500,642])
if docolorbar
    set(gcf, 'position', [ 250  41.6667  600  600])
    colorbar
else
    set(gcf, 'position', [ 360.0000   41.6667  533.6667  599.3333])
end
end

