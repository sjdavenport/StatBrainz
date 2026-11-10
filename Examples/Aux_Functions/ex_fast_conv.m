
%% 2D
lat_data = normrnd(0,1,25,25); FWHM = 3;
smoothed_fast_conv = fast_conv(lat_data, FWHM);
subplot(1,2,1)
surf(smoothed_fast_conv)
title('Surf')
subplot(1,2,2)
imagesc(smoothed_fast_conv)
title('Imagesc')

%% 2D multiple subjects
nsubj = 30; D = 2;
lat_data = normrnd(0,1,25,25,nsubj); FWHM = 3;
smoothed_fast_conv_all = fast_conv(lat_data, FWHM, D);
surf(smoothed_fast_conv_all(:,:,1))

%% 3D
Dim = [50,50,50]; lat_data = normrnd(0,1,Dim); halfDim = Dim(1)/2;
FWHM = 3;
smoothed_fast_conv = fast_conv(lat_data, FWHM);
plot(1:Dim(1),smoothed_fast_conv(:,halfDim,halfDim))

%% Effect on the boundary in 2D
data = ones(10); FWHM = 3;
smoothed_fast_conv = fast_conv(data, FWHM)
figure;
imagesc(smoothed_fast_conv)
title('fast_conv')
colorbar
