%% test_resample_srf
% Tests of the resample_srf function
%--------------------------------------------------------------------------
rng(1)
srf3 = loadsrf('fs3', 'sphere');
srf4 = loadsrf('fs4', 'sphere');

%% Same surface gives the same data
data = randn(srf3.lh.nvertices, 1);
out = resample_srf(data, srf3.lh, srf3.lh);
assert(isequal(out(:), data))

%% fs4 to fs3 takes the first 642 values (nested meshes)
data = randn(srf4.lh.nvertices, 1);
out = resample_srf(data, srf4.lh, srf3.lh);
assert(numel(out) == srf3.lh.nvertices)
assert(isequal(out(:), data(1:642)))

%% Default intertype is nn
out_nn = resample_srf(data, srf4.lh, srf3.lh, 'nn');
out_nn2 = resample_srf(data, srf4.lh, srf3.lh, 'nearestneighbour');
assert(isequal(out, out_nn))
assert(isequal(out, out_nn2))

%% fs3 to fs4: every value is from the input data
data = randn(srf3.lh.nvertices, 1);
out = resample_srf(data, srf3.lh, srf4.lh);
assert(numel(out) == srf4.lh.nvertices)
assert(all(ismember(out, data)))
assert(isequal(out(1:642), data))

%% Both hemispheres: each hemisphere uses its own data
clear data
data.lh = randn(srf4.lh.nvertices, 1);
data.rh = randn(srf4.rh.nvertices, 1) + 10;
out = resample_srf(data, srf4, srf3);
assert(isequal(out.lh(:), data.lh(1:642)))
assert(isequal(out.rh(:), data.rh(1:642)))

disp('test_resample_srf: all tests passed')
