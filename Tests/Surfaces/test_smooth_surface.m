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
smoothX_left = smooth_surface(X_left, FWHM, path4gifti_left);

surfplot(path4gifti_left, smoothX_left)
