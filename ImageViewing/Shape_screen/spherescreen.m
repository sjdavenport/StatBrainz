function spherescreen(docolorbar)
% fullscreen makes the plot fullscreen
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
    set(gcf, 'position', [ 250  41.6667  730  600])
    colorbar
else
    set(gcf, 'position', [ 360.0000   41.6667  533.6667  599.3333])
end
end

