%% test_fs_smooth
% Tests of the fs_smooth function (at the moment it is a stub)
%--------------------------------------------------------------------------
rng(1)
data = randn(642, 1);

%% The call runs
fs_smooth(data);

%% It returns smoothed data of the same size
out = fs_smooth(data);
assert(isequal(size(out), size(data)))

disp('test_fs_smooth: all tests passed')
