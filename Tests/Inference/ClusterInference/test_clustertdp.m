%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the clustertdp function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
connectivity_criterion = 8; H = 2; E = 0.5;
dim = [50,50]; nsubj = 50; 
% Sig = 0.5*peakgen(1, 10, 8, dim);
% Sig = zeros(dim); Sig(25:26,25) = 3;
% Sig = 0.35*square_signal(dim, 4, {[25,20], [25,30]} );
Sig = 0.35*square_signal(dim, 5, {[25,14], [25,36]} );
data = randn([dim, nsubj]) + Sig;
% FWHM = 0; 
FWHM = 5;
data = fast_conv(data, FWHM, 2);
CDT = 2.3;
threshold_cluster = perm_cluster(data, ones(dim), CDT, connectivity_criterion);

tstat_orig = mvtstat(data);
[number_of_clusters, occurences, sizes, index_locations] = numOfConComps(tstat_orig, CDT, connectivity_criterion);
[surviving_cluster_im, surviving_clusters] = cluster_im( dim, index_locations, threshold_cluster );

subplot(1,2,1)
imagesc(tstat_orig)
title('Original t-stat')
axis off
subplot(1,2,2)
viewthresh(surviving_cluster_im, [1,0.5,0.5])
axis off
title('Cluster extext inference: CDT = 2.3')
fullscreen
BigFont(35)

% Need to code up the bound for 2D!
[tdp_bounds, tp_bounds] = clustertdp( surviving_clusters, threshold_cluster );

%% 3D version
% Generate sample data
sb_dir = statbrainz_maindir;
data_mean = imgload([sb_dir, 'BrainImages/Real_data/DerivedUKB/fullmean.nii']);
data_std = imgload([sb_dir, 'BrainImages/Real_data/DerivedUKB/fullstd.nii']);
nsubj = 30;
FWHM = 5;
data = gen_noise(mask, FWHM, nsubj, data_mean, data_std);

tstat_full = mvtstat(data);
mask = ~isnan(tstat_full).*mask;
tstat_orig = zero2nan(tstat_full.*mask);
slice = [45,45,45];

% Run permutation based clustersize inference
connectivity_criterion = 26;
q = perm_cluster(data, mask, CDT, connectivity_criterion, 0.05)
[number_of_clusters, occurences, sizes, index_locations] = numOfConComps(tstat_orig, CDT, connectivity_criterion);
[ surviving_cluster_im, surviving_clusters, surviving_clusters_vec] = cluster_im( size(mask), index_locations, q );

% Calculate the Cluster TDP lower bounds
figure; set(gcf,'Visible','on')
[tdp_bounds, tp_bounds] = clustertdp( surviving_clusters, q );
disp(tdp_bounds')
tdp_image = zeros([91,109,91]);
for I = 1:length(surviving_clusters_vec)
    tdp_image(surviving_clusters_vec{I}) = tdp_bounds(I);
end
overlay_brain(slice, {NaN}, {NaN}, 1, zero2nan(tdp_image));
h = colorbar('Location', 'southoutside');
h.Color = 'w'; 
h.Position = [0.1    0.125    0.8    0.02];
BigFont(40)
title('True Discovery Proportion Lower bounds', 'Color','white', 'FontSize', 60)