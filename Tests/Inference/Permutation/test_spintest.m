%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the spin_test function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% prepare workspace
clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
srf_sphere = loadsrf('fs4', 'sphere');
tic
rho_store = spintest( X, Y, srf_sphere, 1000, 1 );
toc

%% 
srf = loadsrf('fs4', 'white');
srf_sphere = loadsrf('fs4', 'sphere')
gamma = 0;
FWHM = 4;
X = srf_noise(srf, FWHM);
Y = X;
Y.lh = gamma*X.lh + randn(srf.lh.nvertices, 1);
Y.rh = gamma*X.rh + randn(srf.lh.nvertices, 1);
subplot(1,2,1)
srfplot(srf.lh,X.lh)
subplot(1,2,2)
srfplot(srf.lh,Y.lh)

[threshold, rho_store] = spintest( X, Y, srf_sphere, 1000, 0.05 );

%%
alpha = 0.05;
threshold = prctile(rho_store, 100*(1-alpha) )
rho_store(1)

%% Get the medial wall masks
path4gifti = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_desc-nomedialwall_dparc.label.gii';
g = gifti(path4gifti);
nomedwall_left = g.cdata; 
path4gifti = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-R_desc-nomedialwall_dparc.label.gii';
g = gifti(path4gifti);
nomedwall_right = g.cdata; 



%%
path4gifti_left = 'C:/Users/e12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_white.surf.gii';
path4gifti_right = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-R_white.surf.gii';

srf = gifti2surf(path4gifti_left, path4gifti_right);
FWHM = 4;
X = srf_noise(srf, FWHM);
Y = srf_noise(srf, FWHM);

spherepathloc = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_sphere.surf.gii';
srf_sphere = gifti2surf(spherepathloc, spherepathloc);
tic
[threshold, rho_store] = spintest( X, Y, srf_sphere, 1000 );
toc

threshold
rho_store(1)
