%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the spin_surface function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
srf_white = loadsrf('fs4', 'white');
FWHM = 4;
X = srf_noise(srf_white, 0, 1, 'ones');
smoothX = smooth_surface(srf_white, X, FWHM);

%%
srfplot(srf_white, smoothX)

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
medial_wall = loadmask('fs5', 'medial_wall');
clear nomedwall
nomedwall.lh = double(~medial_wall.lh);
nomedwall.rh = double(~medial_wall.rh);
srf5_white = loadsrf('fs5', 'white');
srfplot(srf5_white.lh, 1-nomedwall.lh, 1)

%% Spin the medial wall mask
sphere = loadsrf('fs5', 'sphere');
[ left_rotations,  right_rotations] = spin_surface( nomedwall, sphere, 100 );

%% Plot some of the rotations
for I = 2:4
    subplot(1,3,I-1)
    srfplot(sphere.lh, left_rotations(:,I))
end
