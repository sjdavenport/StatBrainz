%% test_fs2surf
% Tests of the fs2surf function
%--------------------------------------------------------------------------
srf_dir = [statbrainz_maindir, 'BrainImages/Surface/'];

%% Single hemisphere
srf = fs2surf([srf_dir, 'fs5.lh.white']);
assert(srf.nvertices == 10242)
assert(srf.nfaces == 20480)
assert(isequal(size(srf.vertices), [10242, 3]))
assert(isequal(size(srf.faces), [20480, 3]))
assert(min(srf.faces(:)) == 1 && max(srf.faces(:)) == 10242)
assert(~isfield(srf, 'hemi'))

%% Agrees with the stored fs5 white surface
srf5 = loadsrf('fs5', 'white');
assert(isequal(double(srf.faces), double(srf5.lh.faces)))
assert(max(abs(srf.vertices(:) - double(srf5.lh.vertices(:)))) < 1e-4)

%% Both hemispheres
srf = fs2surf([srf_dir, 'fs5.lh.white'], [srf_dir, 'fs5.rh.white']);
assert(strcmp(srf.lh.hemi, 'lh') && strcmp(srf.rh.hemi, 'rh'))
assert(srf.rh.nvertices == 10242)
assert(max(abs(srf.rh.vertices(:) - double(srf5.rh.vertices(:)))) < 1e-4)
% the left hemisphere is on the left (x < 0 on average)
assert(mean(srf.lh.vertices(:,1)) < 0 && mean(srf.rh.vertices(:,1)) > 0)

disp('test_fs2surf: all tests passed')
