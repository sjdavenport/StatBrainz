%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the srf_scopes function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Simultaneous confidence bands on the fs4 surface
srf = loadsrf('fs4', 'white');
nsubj = 50;
Sig = srf_noise(srf, 4);
data.lh = Sig.lh + randn(srf.lh.nvertices, nsubj);
data.rh = Sig.rh + randn(srf.rh.nvertices, nsubj);
mask.lh = true(srf.lh.nvertices, 1);
mask.rh = true(srf.rh.nvertices, 1);
[ lower_band, upper_band, threshold ] = srf_scopes( data, mask, 1000, 0.05, 1 );
threshold

%% Display the cope sets at c = 0
c = 0;
muhat.lh = mean(data.lh, 2);
muhat.rh = mean(data.rh, 2);
srf_cope_display( srf.lh, upper_band.lh > c, lower_band.lh > c, muhat.lh, c )

%% Only use the vertices in a mask
mask.lh = srf.lh.vertices(:,2) > 0;
mask.rh = srf.rh.vertices(:,2) > 0;
[ lower_band, upper_band ] = srf_scopes( data, mask, 1000, 0.05, 1 );
sum(lower_band.lh ~= 0) % zero outside the mask
