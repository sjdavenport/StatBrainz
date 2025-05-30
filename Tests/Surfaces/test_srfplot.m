%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srfplot function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Illustration
srf = loadsrf( 'hcp');
smooth_data = srf_noise( srf, 20 );
srfplot(srf, smooth_data, 'top', 0, 1)
% caxis([-0.1 0.1]);
colormap('jet')

%%
srfplot(srf.lh, smooth_data.lh, 'right', 0, 1)

%%
srf = loadsrf( 'fs5');
smooth_data = srf_noise( srf, 20 );
srfplot(srf, smooth_data, 'top', 0, 1)

%%
srf = loadsrf( 'fs5');
smooth_data = srf_noise( srf, 20 );
srfplot(srf.lh, smooth_data.lh, 'side', 0, 1)

%%
srfplot(srf.lh, smooth_data.lh, 'side', 1)

%%
srfplot(srf.lh, [], 'side', 0, 0.25)

%%
srfplot(srf.rh, smooth_data.rh, 1)

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
