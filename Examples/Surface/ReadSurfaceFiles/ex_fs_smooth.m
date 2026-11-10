%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the fs_smooth function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fs_smooth is a stub: it does not smooth the data and has no output yet.
srf = loadsrf('fs5', 'white');
data = randn(srf.lh.nvertices, 1);
fs_smooth( data )
