%% test_smooth_surface
% Tests of the smooth_surface function
%--------------------------------------------------------------------------
rng(1)
% Octahedron: 6 vertices, 8 faces, each vertex has 4 neighbours
oct.vertices = [1 0 0; -1 0 0; 0 1 0; 0 -1 0; 0 0 1; 0 0 -1];
oct.faces = [1 3 5; 3 2 5; 2 4 5; 4 1 5; 3 1 6; 2 3 6; 4 2 6; 1 4 6];
oct.nvertices = 6;
oct.nfaces = 8;

%% One iteration: half the value plus half the mean of the neighbours
data = [1 0 0 0 0 0]';
out = smooth_surface(oct, data, 0, 'ones', 1);
expected = [0.5 0 0.125 0.125 0.125 0.125]';
assert(max(abs(out(:) - expected)) < 1e-12)

%% Two iterations
out2 = smooth_surface(oct, data, 0, 'ones', 2);
% apply the one step rule again by hand
nbrs = {[3 4 5 6], [3 4 5 6], [1 2 5 6], [1 2 5 6], [1 2 3 4], [1 2 3 4]};
expected2 = zeros(6,1);
for v = 1:6
    expected2(v) = expected(v)/2 + mean(expected(nbrs{v}))/2;
end
assert(max(abs(out2(:) - expected2)) < 1e-12)

%% Smoothing keeps a constant and the mean
out = smooth_surface(oct, 3*ones(6,1), 0, 'ones', 5);
assert(max(abs(out - 3)) < 1e-12)
data = randn(6,1);
out = smooth_surface(oct, data, 0, 'ones', 3);
assert(abs(mean(out) - mean(data)) < 1e-12)  % all vertices have the same degree

%% FWHM = 0 with the default niters does not change the data
out = smooth_surface(oct, data, 0);
assert(max(abs(out - data)) < 1e-12)

%% Default niters comes from srf_fwhm2niters
srf3 = loadsrf('fs3', 'white');
data = randn(srf3.lh.nvertices, 1);
FWHM = 10;
niters = srf_fwhm2niters(FWHM, srf3.lh);
assert(niters > 0)
out = smooth_surface(srf3.lh, data, FWHM);
out_n = smooth_surface(srf3.lh, data, FWHM, 'ones', niters);
assert(isequal(size(out), size(data)))
assert(max(abs(out - out_n)) < 1e-12)
assert(var(out) < var(data))

%% Several subjects are smoothed one column at a time
data = randn(srf3.lh.nvertices, 3);
out = smooth_surface(srf3.lh, data, 0, 'ones', 2);
assert(isequal(size(out), size(data)))
for J = 1:3
    outJ = smooth_surface(srf3.lh, data(:,J), 0, 'ones', 2);
    assert(max(abs(out(:,J) - outJ)) < 1e-12)
end

%% The dist metric is the same as ones when all edges have the same length
data = randn(6,1);
out_ones = smooth_surface(oct, data, 0, 'ones', 2);
out_dist = smooth_surface(oct, data, 0, 'dist', 2);
assert(max(abs(out_ones - out_dist)) < 1e-12)

%% Both hemispheres with the default niters
srf3 = loadsrf('fs3', 'white');
clear data
data.lh = randn(srf3.lh.nvertices, 1);
data.rh = randn(srf3.rh.nvertices, 1);
out = smooth_surface(srf3, data, FWHM);
assert(max(abs(out.lh - smooth_surface(srf3.lh, data.lh, FWHM))) < 1e-12)
assert(max(abs(out.rh - smooth_surface(srf3.rh, data.rh, FWHM))) < 1e-12)

%% Both hemispheres use the metric and niters that are given
out = smooth_surface(srf3, data, 0, 'ones', 2);
assert(max(abs(out.lh - smooth_surface(srf3.lh, data.lh, 0, 'ones', 2))) < 1e-12)
assert(max(abs(out.rh - smooth_surface(srf3.rh, data.rh, 0, 'ones', 2))) < 1e-12)

disp('test_smooth_surface: all tests passed')
