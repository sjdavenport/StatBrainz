%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the slidergui3 function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
% NB: invoked as slidergui3 (the file name); the declared function name inside
% the file is sliderGUI3 -- a case mismatch in the source.
f2plot = @(p) imagesc(sin(linspace(0,2*pi,50)'*p(1)) * cos(linspace(0,2*pi,50)*p(2)) * p(3));
slidergui3(f2plot, [0.5, 0.5, 0.5], [5, 5, 5], 'freq1', 'freq2', 'scale')
