%% test_addSB2path
% Tests of the addSB2path function. Run from the StatBrainz main directory.
%--------------------------------------------------------------------------

%% The call runs
addSB2path

%% Functions from different modules are on the path
assert(~isempty(which('sigma2FWHM')))
assert(~isempty(which('getregion')))
assert(~isempty(which('statbrainz_maindir')))
assert(~isempty(which('imgload')))

%% The repo main directory is on the path
sbdir = statbrainz_maindir;
assert(exist([sbdir, 'addSB2path.m'], 'file') == 2)
p = strsplit(path, pathsep);
assert(any(strcmp(p, sbdir(1:end-1))) || any(strcmp(p, sbdir)))

%% A warning is given when the folder name is not StatBrainz
% (skipped where lastwarn is not available, e.g. in the MATLAB clone)
try
    lastwarn('');
    has_lastwarn = 1;
catch
    has_lastwarn = 0;
end
if has_lastwarn
    addSB2path
    [msg, ~] = lastwarn;
    if strcmp(sbdir(end-10:end-1), 'StatBrainz')
        assert(isempty(msg))
    else
        assert(contains(msg, 'addSB2path'))
    end
end
