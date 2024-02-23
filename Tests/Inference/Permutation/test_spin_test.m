%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the spin_test function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% prepare workspace
clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get the medial wall masks
path4gifti = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_desc-nomedialwall_dparc.label.gii';
g = gifti(path4gifti);
nomedwall_left = g.cdata; 
path4gifti = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-R_desc-nomedialwall_dparc.label.gii';
g = gifti(path4gifti);
nomedwall_right = g.cdata; 

%%
path4gifti_left = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_white.surf.gii';
path4gifti_right = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-R_white.surf.gii';

srf = gifti2surf(path4gifti_left, path4gifti_right);
FWHM = 4;
X = surf_noise(srf, FWHM);
Y = X;
Y.lh = X.lh + randn(10242, 1);
Y.rh = X.rh + randn(10242, 1);
subplot(1,2,1)
surfplot(srf.lh,X.lh)
subplot(1,2,2)
surfplot(srf.lh,Y.lh)

%%
spherepathloc = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_sphere.surf.gii';
srf_sphere = gifti2surf(spherepathloc, spherepathloc);
tic
rho_store = spintest( X, Y, srf_sphere, 1000, 1 );
toc

%%
alpha = 0.05;
threshold = prctile(rho_store, 100*(1-alpha) )
rho_store(1)


%%
path4gifti_left = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_white.surf.gii';
path4gifti_right = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-R_white.surf.gii';

srf = gifti2surf(path4gifti_left, path4gifti_right);
FWHM = 4;
X = surf_noise(srf, FWHM);
Y = surf_noise(srf, FWHM);

spherepathloc = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_sphere.surf.gii';
srf_sphere = gifti2surf(spherepathloc, spherepathloc);
tic
rho_store = spintest( X, Y, srf_sphere, 1000, 1 );
toc

alpha = 0.05;
threshold = prctile(rho_store, 100*(1-alpha) )
rho_store(1)