%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srfplot function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Illustration
srf = loadsrf( 'fs5');
subplot(1,2,1)
smooth_data = srf_noise( srf, 20 );
srfplot(srf.rh, smooth_data.rh, 0)
hold on
srfplot(srf.lh, smooth_data.lh, 0)

subplot(1,2,2)
srfplot(srf.lh, smooth_data.lh, 0)

%%
clear jointsrf
jointsrf.vertices = [srf.lh.vertices; srf.rh.vertices];
jointsrf.faces = [srf.lh.faces; (srf.rh.faces + srf.lh.nvertices) ];
jointsrf.nfaces = size(jointsrf.faces, 1);
jointsrf.nvertices = size(jointsrf.vertices, 1);

srfplot(jointsrf, [smooth_data.lh; smooth_data.rh])

%%
srfplot(srf, smooth_data, 0, 1, 1, 'left')

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
