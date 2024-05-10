function [ out ] = animatefun( fun, minval, maxval, stepsize, timeval )
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
if ~exist( 'timeval', 'var' )
   % Default value
   timeval = 0.05;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
cvals = minval:stepsize:maxval;
screen_size = get(0, 'ScreenSize');
fig = figure('Position', screen_size);
for I = 1:length(cvals)
    fun(cvals(I))
    % fullscreen
    % axis image
    pause(timeval)
end

end

