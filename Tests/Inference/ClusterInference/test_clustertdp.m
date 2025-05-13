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

