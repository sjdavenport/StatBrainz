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

FWHM = 16;
smoothX_left = smooth_surface(X_left, FWHM, path4gifti_left);
smoothX_right = smooth_surface(X_right, FWHM, path4gifti_right);

surfplot(path4gifti_left, smoothX_left)

%%
spherepathloc = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_sphere.surf.gii';
[ left_rotations,  right_rotations] = spin_surface( smoothX_left, smoothX_right, spherepathloc, 100 );

%%
surfplot(path4gifti_left, left_rotations(8,:)')

%%
spherepathloc = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_sphere.surf.gii';
[ left_rotations,  right_rotations] = spintest( nomedwall_left, nomedwall_right, spherepathloc, 100 );


%%
for I = 1:10
    surfplot(spherepathloc, left_rotations(I,:)')
    pause
end

%%
for I = 1:10
    surfplot(spherepathloc, left_rotations(I,:)')
    pause
end