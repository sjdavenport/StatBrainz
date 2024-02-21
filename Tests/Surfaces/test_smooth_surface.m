%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the smooth_surface function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
path4gifti_left = which('tpl-fsaverage_den-10k_hemi-L_white.surf.gii');
srf = gifti2surf(path4gifti_left);
X_left = randn(srf.nvertices,1);

FWHM = 8;

%%
X_left_smooth = smooth_surface(srf, X_left, FWHM );
X_left_smooth_dist = smooth_surface(srf, X_left, FWHM, 'dist' );

subplot(1,2,1)
surfplot(srf, X_left_smooth)
subplot(1,2,2)
surfplot(srf, X_left_smooth_dist)
% saveim('SurfStat')

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

surfplot(smooth_srf.rh)
var(smooth_srf.rh.data)

%%
