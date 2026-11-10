%% test_loadmask
% Tests of the loadmask function
%--------------------------------------------------------------------------
annot_dir = [statbrainz_maindir, 'BrainImages/Surface/fsaverage4/'];

%% Both hemispheres agree with fsannot2mask
mask = loadmask('fs4', 'bankssts');
assert(isfield(mask, 'lh') && isfield(mask, 'rh'))
assert(isequal(mask.lh, fsannot2mask([annot_dir, 'lh.aparc.annot'], 'bankssts')))
assert(isequal(mask.rh, fsannot2mask([annot_dir, 'rh.aparc.annot'], 'bankssts')))

%% Mask sizes for fs4 and fs5
srf = loadsrf('fs5');
mask5 = loadmask('fs5', 'medial_wall');
assert(numel(mask5.lh) == srf.lh.nvertices)
assert(numel(mask5.rh) == srf.rh.nvertices)
assert(numel(mask.lh) == 2562)
assert(islogical(mask5.lh) && any(mask5.lh) && ~all(mask5.lh))

%% Works from a folder outside the repo
olddir = pwd;
cd(tempdir)
mask_t = loadmask('fs4', 'bankssts');
cd(olddir)
assert(isequal(mask_t, mask))

%% Error for a region that is not in the annotation
err = 0;
try
    loadmask('fs4', 'notaregion');
catch
    err = 1;
end
assert(err == 1)

disp('test_loadmask: all tests passed')
