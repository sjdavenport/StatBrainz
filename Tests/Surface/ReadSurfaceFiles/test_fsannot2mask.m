%% test_fsannot2mask
% Tests of the fsannot2mask function
%--------------------------------------------------------------------------
annotfile = [statbrainz_maindir, 'BrainImages/Surface/fsaverage4/lh.aparc.annot'];

%% Mask size and the region names
[mask, region_names] = fsannot2mask(annotfile, 'bankssts');
assert(islogical(mask))
assert(numel(mask) == 2562)
assert(iscell(region_names) && numel(region_names) == 36)
assert(strcmp(region_names{1}, 'unknown'))
assert(strcmp(region_names{2}, 'bankssts'))
assert(sum(mask) == 31)

%% medial_wall is the same as unknown
m1 = fsannot2mask(annotfile, 'medial_wall');
m2 = fsannot2mask(annotfile, 'unknown');
assert(isequal(m1, m2))
assert(sum(m1) == 204)

%% The regions do not overlap and cover every vertex
total = zeros(2562, 1);
for I = 1:numel(region_names)
    total = total + fsannot2mask(annotfile, region_names{I});
end
assert(all(total == 1))

%% The right hemisphere and fs5
annotfile_rh = [statbrainz_maindir, 'BrainImages/Surface/fsaverage4/rh.aparc.annot'];
mask_rh = fsannot2mask(annotfile_rh, 'precentral');
assert(numel(mask_rh) == 2562 && any(mask_rh))
mask5 = fsannot2mask([statbrainz_maindir, 'BrainImages/Surface/fsaverage5/lh.aparc.annot'], 'bankssts');
assert(numel(mask5) == 10242 && any(mask5))

%% Error for a region that is not in the annotation
err = 0;
try
    fsannot2mask(annotfile, 'notaregion');
catch
    err = 1;
end
assert(err == 1)

disp('test_fsannot2mask: all tests passed')
