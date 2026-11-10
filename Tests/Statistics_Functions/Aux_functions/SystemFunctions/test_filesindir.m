%% test_filesindir
% Tests of the filesindir function.
%--------------------------------------------------------------------------
testdir = fullfile(tempdir, 'test_filesindir');
if exist(testdir, 'dir')
    rmdir(testdir, 's');
end
mkdir(testdir);
names = {'alpha.txt', 'beta.m', 'gamma.txt', '.hidden'};
for I = 1:length(names)
    fid = fopen(fullfile(testdir, names{I}), 'w'); fclose(fid);
end

%% Default: all files that are not hidden
listfiles = filesindir(testdir);
assert(iscell(listfiles))
assert(isequal(sort(listfiles), {'alpha.txt', 'beta.m', 'gamma.txt'}))

%% Only the files that contain the pattern
listfiles = filesindir(testdir, '.txt');
assert(isequal(sort(listfiles), {'alpha.txt', 'gamma.txt'}))
listfiles = filesindir(testdir, 'bet');
assert(isequal(listfiles, {'beta.m'}))

%% A cell array of patterns
listfiles = filesindir(testdir, {'alpha', 'beta'});
assert(isequal(sort(listfiles), {'alpha.txt', 'beta.m'}))

%% hiddenfiles = 1 includes the hidden files
listfiles = filesindir(testdir, NaN, 1);
assert(isequal(sort(listfiles), sort(names)))

%% hiddenfiles = 1 still uses the pattern
listfiles = filesindir(testdir, 'txt', 1);
assert(isequal(sort(listfiles), {'alpha.txt', 'gamma.txt'}))

%% No match gives an empty cell array
listfiles = filesindir(testdir, 'nomatch');
assert(iscell(listfiles) && isempty(listfiles))

%% Default directory is the current directory
olddir = pwd;
cd(testdir)
listfiles = filesindir;
cd(olddir)
assert(isequal(sort(listfiles), {'alpha.txt', 'beta.m', 'gamma.txt'}))

rmdir(testdir, 's');
