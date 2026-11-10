%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the cluster_im function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Keep the clusters that are larger than a threshold
dim = [10,10];
index_locations = { [1,2,3], sub2ind(dim, 5:8, 5:8), 100 };
surviving_cluster_im = cluster_im( dim, index_locations, 2 )

%% Subscripts of the surviving clusters
[surviving_cluster_im, surviving_clusters, surviving_clusters_vec] = ...
                                    cluster_im( dim, index_locations, 2 );
surviving_clusters{2}

%% Clustersize thresholding of smooth noise
rng(1)
dim = [50,50]; FWHM = 4;
[smooth_noise, ss] = fast_conv( randn(dim), FWHM, 2 );
smooth_noise = smooth_noise./sqrt(ss);
[~, ~, ~, index_locations] = numOfConComps( smooth_noise, 1, 8 );
surviving_cluster_im = cluster_im( dim, index_locations, 20 );
subplot(1,2,1); imagesc(smooth_noise > 1); axis image off; title('Above 1')
subplot(1,2,2); imagesc(surviving_cluster_im); axis image off; title('Clusters > 20 voxels')
