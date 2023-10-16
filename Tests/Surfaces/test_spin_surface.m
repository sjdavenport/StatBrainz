%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the spintest function
%%%
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

X_left = randn(10242, 1);
X_right = randn(10242, 1);

FWHM = 2;
smoothX_left = smooth_surface(X_left, FWHM, path4gifti_left);
smoothX_right = smooth_surface(X_right, FWHM, path4gifti_right);

%%
surfplot(path4gifti_left, smoothX_left)
surfscreen
% saveim('noise')
%%
surfplot(spherepathloc, smoothX_left)
spherescreen
saveim('spherenoise')
%%
spherepathloc = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_sphere.surf.gii';
[ left_rotations,  right_rotations] = spin_surface( smoothX_left, smoothX_right, spherepathloc, 20 );

%%
surfplot(path4gifti_left, left_rotations(:,8), 0, 0.05, 0)

%%
surfplot(spherepathloc, left_rotations(:,I), 0, 0.05, 0)
spherescreen

%%
surfplot(path4gifti_left, left_rotations(:,8))

%%
surfplot(spherepathloc, left_rotations(:,I))
spherescreen

%%
spherepathloc = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_sphere.surf.gii';
[ left_rotations,  right_rotations] = spin_surface( nomedwall_left, nomedwall_right, spherepathloc, 100 );

%%
for I = 1:20
    surfplot(path4gifti_left, left_rotations(:,I))
    surfscreen
    pause
end

%%
surfplot(path4gifti_left, nomedwall_left, 1)
surfscreen
saveim('medialwall')

%%
for I = 2:4
    surfplot(spherepathloc, left_rotations(:,I))
    spherescreen
    saveim(['sphererot_', num2str(I)])
end

%%
surfplot(path4gifti_left, left_rotations(:,I), 1, 0.05, 1 )