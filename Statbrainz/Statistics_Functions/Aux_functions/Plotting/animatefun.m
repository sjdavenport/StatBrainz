function [ out ] = animatefun( fun, minval, maxval, stepsize, timeval )
% ANIMATEFUN animates a function over a range of values.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  fun        a function handle accepting a single scalar value to plot
%  minval     the minimum value of the animation parameter
%  maxval     the maximum value of the animation parameter
%  stepsize   the step size between successive animation frames
% Optional
%  timeval    pause duration in seconds between frames; default is 0.05
%--------------------------------------------------------------------------
% OUTPUT
%  out        (unused) placeholder output
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

