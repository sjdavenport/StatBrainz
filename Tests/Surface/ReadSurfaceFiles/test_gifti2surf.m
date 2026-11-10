%% test_gifti2surf
% Tests of the gifti2surf function
%--------------------------------------------------------------------------
gifti_dir = [statbrainz_maindir, 'BrainImages/Gifti_files/'];

%% Single hemisphere
srf = gifti2surf([gifti_dir, 'lh_10242.gii']);
assert(srf.nvertices == 10242)
assert(srf.nfaces == 20480)
assert(isequal(size(srf.vertices), [10242, 3]))
assert(min(srf.faces(:)) == 1 && max(srf.faces(:)) == 10242)

%% Agrees with the stored fs5 white surface
srf5 = loadsrf('fs5', 'white');
assert(isequal(double(srf.faces), double(srf5.lh.faces)))
assert(max(abs(double(srf.vertices(:)) - double(srf5.lh.vertices(:)))) < 1e-4)

%% Both hemispheres
srf = gifti2surf([gifti_dir, 'lh_10242.gii'], [gifti_dir, 'rh_10242.gii']);
assert(strcmp(srf.lh.hemi, 'lh') && strcmp(srf.rh.hemi, 'rh'))
assert(srf.rh.nvertices == 10242)
assert(max(abs(double(srf.rh.vertices(:)) - double(srf5.rh.vertices(:)))) < 1e-4)

%% A 32k HCP surface
srf = gifti2surf([gifti_dir, 'S1200.L.inflated_MSMAll.32k_fs_LR.surf.gii']);
assert(srf.nvertices == 32492)
assert(srf.nfaces == 64980)

disp('test_gifti2surf: all tests passed')
