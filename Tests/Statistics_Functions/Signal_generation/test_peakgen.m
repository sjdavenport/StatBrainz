%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the peakgen function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% 1D signal (NEED TO IMPLEMENT FOR 1D)! -- peakgen does not yet support the
% 1D case, so this example errors; left commented out.
% Sig = peakgen( 1, 3, 6, 100 )

%%
% 2D signal without smoothing
Sig = peakgen([1,2], 3, [0,0], [100,150], {[40,30], [70,120]});
surf(Sig)

%%
% 2D signal with smoothing
Sig = peakgen([1,2], 3, [10,20], [100,150], {[40,30], [70,120]});
surf(Sig)

%%
% 2D Single peak plus noise
Sig = peakgen(1, 10, 8, [90,90]); nsubj = 20;
surf(Sig)
lat_data = randn([90,90,nsubj]) + Sig;
surf(mean(lat_data,3))
