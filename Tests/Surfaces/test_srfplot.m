%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srfplot function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Illustration
srf = loadsrf( 'fs5');
data = randn(srf.lh.nvertices, 1);
smooth_data = smooth_surface(srf.lh, data, 20);
srfplot(srf.lh, smooth_data, 1)

%%
srf = loadsrf( 'fs5');
data = randn(srf.rh.nvertices, 1);
smooth_data = smooth_surface(srf.rh, data, 20);
srfplot(srf.rh, smooth_data, 1)

%%
srf = loadsrf( 'hcp');
data = randn(64980, 1);
smooth_data = smooth_surface(srf.lh, data, 1, 'ones', 1);
srfplot(srf.lh, smooth_data)

%%
path4gifti_left = which('tpl-fsaverage_den-10k_hemi-L_white.surf.gii');
X_left = randn(10242*2-4, 1);

subplot(1,2,1)
srfplot(path4gifti_left, X_left(1:10242))
subplot(1,2,2)
srfplot(path4gifti_left, X_left)

%%
srf = loadsrf;
srfplot(srf)
