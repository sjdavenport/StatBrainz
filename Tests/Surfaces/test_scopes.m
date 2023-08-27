%% Comparing cluster size inference and scopes
[ lower_band, upper_band ] = scopes( data, 1000, 0.05 );
c_vec = 0:0.25:0.5;
subplot(1,length(c_vec)+1,1)
imagesc(surviving_cluster_im)
axis square
title('Cluster size inference')
for I = 1:length(c_vec)
    subplot(1, length(c_vec)+1,I+1)
    cope_display( upper_band > c_vec(I), lower_band > c_vec(I), mean(data,3), c_vec(I));
    title(['SCOPES, c = ', num2str(c_vec(I))])
end

%% Real data example
subjectids = filesindir('C:\Users\12SDa\davenpor\Data\HCP\HCPContrasts\WM\');

WM_imgs = zeros([91,109,91,80]);
for I = 1:length(subjectids)
    modul(I,10)
    subject_file_loc = ['C:\Users\12SDa\davenpor\Data\HCP\HCPContrasts\WM\',...
                                    subjectids{I}, '\WM\Level2\cope11.nii.gz'];
    WM_imgs(:,:,:,I) = imgload(subject_file_loc);
end

%%
slice = 35;
WM_imgs_2D = squeeze(WM_imgs(:,:,slice,:));
MNImask = imgload('MNImask');
MNImask2D = MNImask(:,:,slice);
[ lower_band, upper_band ] = scopes( WM_imgs_2D.*MNImask(:,:,slice), 1000, 0.05, 1 );
c_vec = [0,5,10];
%%
for I = 1:length(c_vec)
    disp(I)
    subplot(1, length(c_vec),I)
    I
    lower_set = upper_band > c_vec(I);
    lower_set = lower_set.*MNImask2D;
    upper_set = lower_band > c_vec(I);
    upper_set = upper_set.*MNImask2D;
    cope_display(lower_set, upper_set, mean(WM_imgs_2D,3).*MNImask2D, c_vec(I));
    title(['SCOPES, c = ', num2str(c_vec(I))])
end

%%
[lower_set, upper_set, std_multipler] = sss_cope_sets(data, mask, ... 
                                                    thresh, nBoot, quant2use)

%%
FWHM_sig = 5;
dim = [50,50];
nsubj = 100;
Sig = fconv(wfield(dim, 1).field, FWHM_sig, 2);

data = wfield(dim, nsubj).field + Sig;
FWHM_applied = 5;

% smoothed_data = fconv(data, FWHM_applied, 2);
params = ConvFieldParams([FWHM_applied, FWHM_applied], 3, 0);
data_field = Field(data, ones(dim)>0);
smoothed_data = convfield(data_field, params);
mask = smoothed_data.mask;
smoothed_data = smoothed_data.field;
c_vec = 0:0.1:0.2;
[ lower_band, upper_band ] = scopes( smoothed_data, mask, 1000, 0.05, 1 );

smooth_Sig = convfield(Sig, params).field;

%%
figure 
c_vec = 0.05:0.05:0.2;
for I = 1:length(c_vec)
    subplot(2,2,I)
    cope_display( upper_band > c_vec(I), lower_band > c_vec(I), mean(smoothed_data,3), c_vec(I), smooth_Sig, 1, 0, 1.5);
%     cope_display( upper_band > c_vec(I), lower_band > c_vec(I), mean(smoothed_data,3), c_vec(I), smooth_Sig, 1, 1, 2, 1);
    title(['SCOPES, c = ', num2str(c_vec(I))])
end
fullscreen

%%
c_vec = -0.1:0.001:0.2;
number_of_signal_clusters = zeros(1, length(c_vec));
number_of_estimated_clusters = zeros(1, length(c_vec));
number_of_blue_clusters = zeros(1, length(c_vec));
number_of_red_clusters = zeros(1, length(c_vec));
data_mean = mean(smoothed_data, 3);
smooth_Sig = fconv(Sig, FWHM_applied, 2);
for I = 1:length(c_vec)
    number_of_signal_clusters(I) = numOfConComps(smooth_Sig, c_vec(I), 8);
    number_of_estimated_clusters(I) = numOfConComps(data_mean, c_vec(I), 8);
    lower_set = upper_band > c_vec(I);
    upper_set = lower_band > c_vec(I);
    number_of_blue_clusters(I) = numOfConComps(lower_set, 0.5, 8);
    number_of_red_clusters(I) = numOfConComps(upper_set, 0.5, 8);
end

plot(c_vec, number_of_signal_clusters, 'black')
hold on
plot(c_vec, number_of_estimated_clusters, 'yellow')
plot(c_vec, number_of_blue_clusters, 'blue')
plot(c_vec, number_of_red_clusters, 'red')
