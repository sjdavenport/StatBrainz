%% test_mgzwrite
% Tests of the mgzwrite function. Writing needs save_mgh2 from the
% FreeSurfer MATLAB folder on the path.
%--------------------------------------------------------------------------
rng(1)
vol = randn([5, 6, 7]);

%% Error for a filename that does not end in .mgh or .mgz
err = 0;
try
    mgzwrite(vol, [tempdir, 'test_mgzwrite.nii']);
catch
    err = 1;
end
assert(err == 1)

%% Write an .mgh file
filename = [tempdir, 'test_mgzwrite.mgh'];
if exist(filename, 'file'), delete(filename); end
mgzwrite(vol, filename);
assert(exist(filename, 'file') == 2)
delete(filename)

%% Write an .mgz file: only the .mgz is left
filename = [tempdir, 'test_mgzwrite.mgz'];
if exist(filename, 'file'), delete(filename); end
mgzwrite(vol, filename);
assert(exist(filename, 'file') == 2)
assert(exist([tempdir, 'test_mgzwrite.mgh'], 'file') == 0)
delete(filename)

disp('test_mgzwrite: all tests passed')
