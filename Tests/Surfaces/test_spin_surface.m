%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the spin_surface function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
srf_white = loadsrf('fs4', 'white');
FWHM = 4;
X = srf_noise(srf, 0, 1, 'ones');
smoothX = smooth_surface(srf, X, FWHM);

%%
srfplot(srf, smoothX)

%%
srf_sphere = loadsrf('fs4', 'sphere');
srfplot(srf_sphere.lh, smoothX.lh, 0, 1)

%%
srf_sphere = loadsrf('fs4', 'sphere');
[ left_rotations,  right_rotations] = spin_surface( smoothX, srf_sphere, 20 );

%%
subplot(1,2,1)
srfplot(srf_white.lh, left_rotations(:,8))
subplot(1,2,2)
srfplot(srf_sphere.lh, left_rotations(:,8))

%% Get the medial wall masks
path4gifti = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_desc-nomedialwall_dparc.label.gii';
g = gifti(path4gifti);
nomedwall_left = g.cdata; 
path4gifti = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-R_desc-nomedialwall_dparc.label.gii';
g = gifti(path4gifti);
nomedwall_right = g.cdata; 

%%
clear nomedwall
medialwall_leftpath = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_desc-nomedialwall_dparc.label.gii';
g = gifti(medialwall_leftpath);
nomedwall.lh.data = g.cdata;
srfplot(g,  g.cdata)

%%
medialwall_rightpath = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-R_desc-nomedialwall_dparc.label.gii';
g = gifti(medialwall_rightpath);
nomedwall.rh.data = g.cdata;

spherepathloc = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_sphere.surf.gii';
sphere = gifti2surf(spherepathloc, spherepathloc);

[ left_rotations,  right_rotations] = spin_surface( nomedwall, sphere, 100 );

%%
path4gifti_left = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_white.surf.gii';
for I = 1:20
    surfplot(path4gifti_left, left_rotations(:,I), 1)
    surfscreen
    pause
end

%%
path4gifti_left = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_white.surf.gii';
srfplot(path4gifti_left, 1-nomedwall_left, 1)
surfscreen
% saveim('medialwall')

%%
for I = 2:4
    surfplot(spherepathloc, left_rotations(:,I))
    spherescreen
    saveim(['sphererot_', num2str(I)])
end

%%
surfplot(path4gifti_left, left_rotations(:,I), 1, 0.05, 1 )

%%
srf = loadsrf('')