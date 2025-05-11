%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the LCE function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 2D 
rng(1)
connectivity_criterion = 8; H = 2; E = 0.5; dim = [50,50];
nsubj = 50; FWHM = 5;
Sig = 0.1*square_signal(dim, 10, {[25,15], [25,36]} );

data = randn([dim, nsubj]) + Sig;
data = fast_conv(data, FWHM, 2);
tstat_orig = mvtstat(data);
tfce_tstat = tfce(tstat_orig, H, E, connectivity_criterion);
subplot(1,2,1); imagesc(tstat_orig); axis off
subplot(1,2,2); imagesc(tfce_tstat); axis off

%%
figure; set(gcf,'Visible','on')
[threshold_tfce, vec_of_maxima_tfce] = perm_tfce(data, ones(dim), H, E, connectivity_criterion);
subplot(1,2,1); viewthresh(tfce_tstat > threshold_tfce, [1,0,0], [1,1,1]); title('TFCE', 'color', 'white');

[number_of_tfce_clusters, ~, ~, index_locations] = numOfConComps(tfce_tstat, threshold_tfce, connectivity_criterion);
[ surviving_tfce_cluster_im, surviving_tfce_clusters, surviving_tfce_clusters_vec] = cluster_im( size(tfce_tstat), index_locations, 0.5 );

[pvals, max_tfce_within_region] = LCE(tstat_orig, surviving_tfce_clusters_vec, vec_of_maxima_tfce)
lce_significant_clusters_vec = surviving_tfce_clusters_vec(pvals < 0.05);
lce_cluster_im = cluster_im( size(tfce_tstat), lce_significant_clusters_vec, 0.5 );

subplot(1,2,1); viewthresh(tfce_tstat > threshold_tfce, [0.5,1,1]); title('TFCE', 'color', 'white');
subplot(1,2,2); viewthresh(lce_cluster_im, [1,0.5,0.5]); title('LCE', 'color', 'white');
fullscreen
BigFont(40)
set(gcf, 'Color', [0.3,0.3,0.3]);

%% 3D
MNImask = imgload('MNImask');
nvox = sum(MNImask(:));
nsubj = 30;

noise = randn([size(MNImask), nsubj]);
FWHM = 8;
[smooth_noise, ss] = fast_conv(noise, FWHM, 3);

smooth_noise = smooth_noise.*MNImask./sqrt(ss); %Zero out stuff outside of the mask

region_masks = atlas_masks('HOc');

signal = region_masks{1} + region_masks{40} + region_masks{30};

data = smooth_noise + signal;

tstat_orig = mvtstat(data);
tstat_orig = nan2zero(tstat_orig.*MNImask);

% Run TFCE
h0 = 3.1; connectivity_criterion = 26; H = 2; E = 0.5; dh = 0.1;
[threshold_tfce, vec_of_maxima_tfce] = perm_tfce(data, MNImask, H, E, connectivity_criterion, dh, h0, 0.05, 1000);

% Run LCE
pvals = LCE(tstat_orig, region_masks, vec_of_maxima_tfce, H, E, connectivity_criterion, dh, h0, 1);

find(pvals < 0.05)