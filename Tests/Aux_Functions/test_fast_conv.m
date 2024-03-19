
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
D = length(Dim);
smoothed_spm = zeros(Dim);
spm_smooth(lat_data, smoothed_spm, FWHM);
smoothed_fast_conv = fast_conv_dep(lat_data, FWHM);
sigma = FWHM2sigma(FWHM); truncation = ceil(6*sigma);
smoothed_fast_conv_spmkern = fast_conv_dep(lat_data, @(x) spm_smoothkern(FWHM, x), 3, NaN, truncation );
smoothed_cfield = convfield( lat_data, FWHM, 1, D, 0, 0);
plot(1:Dim(1),smoothed_fast_conv(:,halfDim,halfDim))
hold on 
plot(1:Dim(1),smoothed_spm(:,halfDim,halfDim))
plot(1:Dim(1),smoothed_cfield(:,halfDim,halfDim), '--')
plot(1:Dim(1),smoothed_fast_conv_spmkern(:,halfDim,halfDim), '--')
legend('fast_conv', 'SPM', 'convfield', 'fast_conv\_smoothkern')

%%
plot(-truncation:truncation, spm_smoothkern(FWHM, -truncation:truncation))
hold on
plot(-truncation:truncation, GkerMV(-truncation:truncation, FWHM))

%% Compare speed to spm_smooth (much faster)
Dim = [50,50,50]; lat_data = normrnd(0,1,Dim);
tic; fast_conv(lat_data, FWHM); toc
tic; smoothed_spm = zeros(Dim);
tt = spm_smooth_mod(lat_data, smoothed_spm, FWHM); toc

%% Comparing effect on the boundary with SPM in 2D
data = ones(10); FWHM = 3;
smoothed_spm = zeros(size(data));
spm_smooth(data, smoothed_spm, FWHM);

smoothed_fast_conv = fast_conv(data, FWHM)

figure; subplot(1,2,1);
imagesc(smoothed_spm)
title('spm')
colorbar
subplot(1,2,2);
imagesc(smoothed_fast_conv)
title('fast_conv')

%% Comparing effect on the boundary with SPM in 3D
data = ones([10,10,10]); FWHM = 3;
smoothed_spm = zeros(size(data));
spm_smooth(data, smoothed_spm, FWHM);

smoothed_fast_conv = fast_conv(data, @(x) spm_smoothkern(FWHM,x), 3, 10);

figure; subplot(1,2,1);
surf(smoothed_spm(:,:,5))
title('spm')
subplot(1,2,2);
surf(smoothed_fast_conv(:,:,5))
title('fast_conv')

%%
figure; subplot(1,2,1);
surf(smoothed_spm(:,:,1))
title('spm')
subplot(1,2,2);
surf(smoothed_fast_conv(:,:,1))
title('fast_conv')
