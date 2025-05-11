%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the clustertdp function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
rng(1)
connectivity_criterion = 8; H = 2; E = 0.5; dim = [50,50];
nsubj = 50; FWHM = 5;
Sig = 0.1*square_signal(dim, 10, {[25,15], [25,36]} );

data = randn([dim, nsubj]) + Sig;
data = fast_conv(data, FWHM, 2);
tstat_orig = mvtstat(data);
imagesc(tstat_orig); axis off

%%
connectivity_criterion = 26;
q = perm_cluster(data, mask, CDT, connectivity_criterion)
[number_of_clusters, occurences, sizes, index_locations] = numOfConComps(tstat_orig, CDT, connectivity_criterion);
[ surviving_cluster_im, surviving_clusters, surviving_clusters_vec] = cluster_im( size(mask), index_locations, q );


%%
figure; set(gcf,'Visible','on')
[threshold_tfce, vec_of_maxima_tfce] = perm_tfce(data, ones(dim), H, E, connectivity_criterion);
subplot(1,2,1); viewthresh(tfce_tstat > threshold_tfce, [1,0,0], [1,1,1]); title('TFCE', 'color', 'white');

viewthresh(tfce_tstat > threshold_tfce, [0.5,1,1]); title('TFCE', 'color', 'white');

[number_of_clusters, occurences, sizes, index_locations] = numOfConComps(tstat_orig, CDT, connectivity_criterion);
[ surviving_cluster_im, surviving_clusters, surviving_clusters_vec] = cluster_im( size(mask), index_locations, threshold_cluster );
