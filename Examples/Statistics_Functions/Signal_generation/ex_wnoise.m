%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the wnoise function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Gaussian noise on a 4 x 2 x 3 grid
noise = wnoise( [4 2 3] );
size(noise)

%%
% 100 subjects of 2D Gaussian noise, smoothed with fast_conv
noise = wnoise( [50 50], 100 );
smooth_noise = fast_conv( noise, 4, 2 );
imagesc(smooth_noise(:,:,1))

%%
% t (3 degrees of freedom) and Laplacian (scale 1) noise
tnoise = wnoise( [5 5], 10, 'T', 3 );
lnoise = wnoise( [5 5], 10, 'L', 1 );
histogram(lnoise(:))
