%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the smooth_surface function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
srf = loadsrf;
clear data
data.lh = randn(srf.lh.nvertices, 1);
data.rh = randn(srf.rh.nvertices, 1);
FWHM = 15;
smooth_data = smooth_surface(srf, data, FWHM);
srfplot(srf.lh, smooth_data.lh)

%%
path4gifti_left = which('tpl-fsaverage_den-10k_hemi-L_white.surf.gii');
srf = gifti2surf(path4gifti_left);
X_left = randn(srf.nvertices,1);

FWHM = 8;
X_left_smooth = smooth_surface(srf, X_left, FWHM );


%%
FWHM = 20;
X_left_smooth = smooth_surface(srf, X_left, FWHM );
X_left_smooth_dist = smooth_surface(srf, X_left, FWHM, 'dist' );

subplot(1,2,1)
srfplot(srf, X_left_smooth)
subplot(1,2,2)
srfplot(srf, X_left_smooth_dist)
% saveim('SurfStat')

%%
plot(X_left_smooth, X_left_smooth_dist, '*')

%%
adj_matrix = adjacency_matrix(smoothX_left, 'ones');


%%
clear srf
path4gifti_left = which('tpl-fsaverage_den-10k_hemi-L_white.surf.gii');
srf = gifti2surf(path4gifti_left, path4gifti_left);
srf.lh.data = randn(10242,1);
srf.rh.data = randn(10242,1);
smooth_srf = smooth_surface(srf, 3);

srfplot(smooth_srf.rh)
var(smooth_srf.rh.data)

%%
fs5 = loadsrf('fs5', 'sphere');
fs6 = loadsrf('fs6', 'sphere');

data = randn(fs6.lh.nvertices, 1);
data = smooth_surface(fs6.lh, data, 10);
resampled_data = resample_srf( data, fs6.lh, fs5.lh);

FWHM = 30;
smoothed_data = smooth_surface(fs6.lh, data, FWHM);
smoothed_resampled_data = smooth_surface(fs5.lh, resampled_data, FWHM);

subplot(1,2,1)
srfplot(fs6.lh, smoothed_data)
subplot(1,2,2)
srfplot(fs5.lh, smoothed_resampled_data)
