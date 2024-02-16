%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the smooth_surface function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
path4gifti_left = which('tpl-fsaverage_den-10k_hemi-L_white.surf.gii');

X_left = randn(10242, 1);
X_right = randn(10242, 1);

FWHM = 8;
smoothX_left = smooth_surface(path4gifti_left, FWHM, X_left);

surfplot(path4gifti_left, smoothX_left)
% saveim('SurfStat')

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
