%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the spin_surface function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
path4gifti_left = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_white.surf.gii';
path4gifti_right = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-R_white.surf.gii';

X = gifti2surf(path4gifti_left, path4gifti_right);
X.lh.data = randn(10242, 1);
X.rh.data = randn(10242, 1);

FWHM = 4;
smoothX = smooth_surface(X, FWHM);

%%
surfplot(smoothX.lh)
surfscreen
% saveim('noise')
%%
spherepathloc = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_sphere.surf.gii';
surfplot(spherepathloc, smoothX.lh.data)
spherescreen
% saveim('spherenoise')

%%
% [ left_rotations,  right_rotations] = spin_surface( smoothX_left.data, smoothX_right.data, spherepathloc, 20 );
spherepathloc = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_sphere.surf.gii';
sphere = gifti2surf(spherepathloc, spherepathloc);

[ left_rotations,  right_rotations] = spin_surface( smoothX, sphere, 20 );

%%
subplot(1,2,1)
surfplot(path4gifti_left, left_rotations(:,8))
subplot(1,2,2)
surfplot(spherepathloc, left_rotations(:,8))

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