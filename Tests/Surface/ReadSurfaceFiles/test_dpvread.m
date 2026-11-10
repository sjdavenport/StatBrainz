%% test_dpvread
% Tests of the dpvread function
%--------------------------------------------------------------------------
rng(1)
nvertices = 6;
dpv = [(0:nvertices-1)', round(randn(nvertices, 3)*1000)/1000, (1:nvertices)'*0.5];
filename = [tempdir, 'test_dpvread.dpv'];
fid = fopen(filename, 'w');
fprintf(fid, '%d %.3f %.3f %.3f %.3f\n', dpv');
fclose(fid);

%% Read all the vertices
out = dpvread(filename, nvertices);
assert(isequal(size(out), [nvertices, 5]))
assert(max(abs(out(:) - dpv(:))) < 1e-12)

%% Read the first vertices only
out = dpvread(filename, 2);
assert(isequal(size(out), [2, 5]))
assert(max(abs(out(:) - reshape(dpv(1:2,:), [], 1))) < 1e-12)

%% One vertex
out = dpvread(filename, 1);
assert(isequal(out, dpv(1,:)))

%% Error for a file that does not exist
delete(filename)
err = 0;
try
    dpvread(filename, nvertices);
catch
    err = 1;
end
assert(err == 1)

disp('test_dpvread: all tests passed')
