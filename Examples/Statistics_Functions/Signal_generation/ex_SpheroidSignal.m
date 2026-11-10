%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the SpheroidSignal function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% 2D signal without smoothing
Sig = SpheroidSignal([100, 100], 10, 3, 0);
surf(Sig)

%%
% 2D signal with smoothing, centred away from the middle
Sig = SpheroidSignal([100, 100], 10, 2, 6, [30, 70]);
surf(Sig)

%%
% 3D signal with smoothing
Sig = SpheroidSignal([50, 50, 50], 8, 3, 4);
subplot(1,2,1); imagesc(Sig(:,:,25))
subplot(1,2,2); imagesc(Sig(:,:,31))
