%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the numOfConComps function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

thresh = 1;
sims = randn(10,10)
[number_of_clusters, occurences, sizes, index_locations] = numOfConComps(sims, thresh);
sims > thresh
sizes

%%
dim = [25,25]; noise = randn(dim); FWHM = 4;
smooth_noise = fast_conv(noise, FWHM, 2);
[number_of_clusters, occurences, sizes, index_locations] = numOfConComps(smooth_noise, 1);
surviving_cluster_im = cluster_im( dim, index_locations, 25 )
imagesc(surviving_cluster_im)
