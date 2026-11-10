%% test_loadsrf
% Tests of the loadsrf function
%--------------------------------------------------------------------------

%% Default surface is fs5 white
srf = loadsrf;
srf5 = loadsrf('fs5', 'white');
assert(isequal(srf, srf5))
srf_id = loadsrf('fs5');
assert(isequal(srf_id, srf5))

%% Both hemispheres with the hemi field
assert(isfield(srf, 'lh') && isfield(srf, 'rh'))
assert(strcmp(srf.lh.hemi, 'lh'))
assert(strcmp(srf.rh.hemi, 'rh'))

%% Sizes of the fsaverage icosahedral meshes
ids = {'fs3', 'fs4', 'fs5'};
for I = 1:length(ids)
    k = I + 2;
    nv = 10*4^k + 2;        % vertices of an order k icosphere
    nf = 2*nv - 4;          % Euler characteristic of a closed surface
    srf = loadsrf(ids{I}, 'white');
    for hemi = {'lh', 'rh'}
        h = hemi{1};
        assert(srf.(h).nvertices == nv)
        assert(srf.(h).nfaces == nf)
        assert(isequal(size(srf.(h).vertices), [nv, 3]))
        assert(isequal(size(srf.(h).faces), [nf, 3]))
        assert(min(srf.(h).faces(:)) == 1)
        assert(max(srf.(h).faces(:)) == nv)
    end
end

%% All surface types have the same mesh
white = loadsrf('fs3', 'white');
for type = {'pial', 'sphere', 'inflated'}
    srf = loadsrf('fs3', type{1});
    assert(isequal(srf.lh.faces, white.lh.faces))
    assert(srf.lh.nvertices == white.lh.nvertices)
    assert(~isequal(srf.lh.vertices, white.lh.vertices))
end

%% The sphere has radius 100
srf = loadsrf('fs4', 'sphere');
radius = sqrt(sum(double(srf.lh.vertices).^2, 2));
assert(all(abs(radius - 100) < 1))

%% fs5 white is the same as the FreeSurfer geometry file
srf_dir = [statbrainz_maindir, 'BrainImages/Surface/'];
fs = fs2surf([srf_dir, 'fs5.lh.white'], [srf_dir, 'fs5.rh.white']);
assert(max(abs(fs.lh.vertices(:) - double(srf5.lh.vertices(:)))) < 1e-4)
assert(isequal(double(fs.rh.faces), double(srf5.rh.faces)))

%% HCP surface
srf = loadsrf('hcp');
assert(srf.lh.nvertices == 32492)
assert(srf.rh.nvertices == 32492)

%% Errors for a bad surface type or id
err = 0;
try
    loadsrf('fs5', 'notatype');
catch
    err = 1;
end
assert(err == 1)

err = 0;
try
    loadsrf('fs9', 'white');
catch
    err = 1;
end
assert(err == 1)

disp('test_loadsrf: all tests passed')
