%% test_statbrainz_maindir
% Tests of the statbrainz_maindir function.
%--------------------------------------------------------------------------

%% Returns a directory that ends with a file separator
maindir = statbrainz_maindir;
assert(ischar(maindir))
assert(any(maindir(end) == '/\'))
assert(exist(maindir, 'dir') == 7)

%% The directory is the main StatBrainz directory
assert(exist([maindir, 'addSB2path.m'], 'file') == 2)
assert(exist([maindir, 'Statistics_Functions/Aux_functions/SystemFunctions/statbrainz_maindir.m'], 'file') == 2)
assert(exist([maindir, 'BrainImages'], 'dir') == 7)
