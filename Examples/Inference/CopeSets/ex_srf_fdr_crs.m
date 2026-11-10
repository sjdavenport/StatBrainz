%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the srf_fdr_crs function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FDR cope sets on the fs4 surface
srf = loadsrf('fs4', 'white');
nsubj = 30; c = 0;
mu = srf_noise(srf, 4);
data.lh = mu.lh + randn(srf.lh.nvertices, nsubj);
data.rh = mu.rh + randn(srf.rh.nvertices, nsubj);
mask.lh = true(srf.lh.nvertices, 1);
mask.rh = true(srf.rh.nvertices, 1);
[lower_set, upper_set] = srf_fdr_crs( data, mask, c );
[sum(lower_set.lh), sum(upper_set.lh)]

%% Display the cope sets on the left hemisphere
srf_cope_display( srf.lh, lower_set.lh > 0, upper_set.lh > 0, mean(data.lh, 2), c )

%% Use a mask and a different alpha level
mask.lh = srf.lh.vertices(:,2) > 0;
mask.rh = srf.rh.vertices(:,2) > 0;
[lower_set, upper_set] = srf_fdr_crs( data, mask, c, 0.1 );
[sum(lower_set.lh), sum(upper_set.lh)]
