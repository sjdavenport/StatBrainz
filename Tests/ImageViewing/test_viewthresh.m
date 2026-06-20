%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the viewthresh function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dim = [50,50]; radii = 5;
signal = square_signal(dim, radii )
imagesc(signal)
signal = square_signal(dim, 4, {[25,20], [25,30]} )
viewthresh(signal, [1,0,0])
