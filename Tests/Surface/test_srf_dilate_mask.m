%% test_srf_dilate_mask
% Tests of the srf_dilate_mask function
%--------------------------------------------------------------------------
% Octahedron: 6 vertices, 8 faces, each vertex has 4 neighbours
% (vertex 1 is next to 3, 4, 5, 6 but not to 2)
oct.vertices = [1 0 0; -1 0 0; 0 1 0; 0 -1 0; 0 0 1; 0 0 -1];
oct.faces = [1 3 5; 3 2 5; 2 4 5; 4 1 5; 3 1 6; 2 3 6; 4 2 6; 1 4 6];
oct.nvertices = 6;
oct.nfaces = 8;

%% Dilation of one vertex adds its neighbours
mask = logical([1 0 0 0 0 0]');
d1 = srf_dilate_mask(oct, mask, 1);
assert(islogical(d1))
assert(isequal(d1(:), logical([1 0 1 1 1 1]')))

%% Two dilations cover the octahedron
d2 = srf_dilate_mask(oct, mask, 2);
assert(all(d2))

%% Zero dilation returns the mask
d0 = srf_dilate_mask(oct, mask, 0);
assert(isequal(d0, mask))

%% Erosion removes the vertices next to the outside
mask = logical([1 0 1 1 1 1]');
e1 = srf_dilate_mask(oct, mask, -1);
assert(isequal(logical(e1(:)), logical([1 0 0 0 0 0]')))
e2 = srf_dilate_mask(oct, mask, -2);
assert(~any(e2))

%% On a surface: compare with the adjacency matrix
rng(1)
srf = loadsrf('fs3', 'sphere');
mask = srf_noise(srf.lh, 10) > 0;
A = adjacency_matrix(srf.lh);
d1 = srf_dilate_mask(srf.lh, mask, 1);
assert(isequal(d1(:), mask | (A*double(mask) > 0)))
d2 = srf_dilate_mask(srf.lh, mask, 2);
assert(isequal(d2(:), d1 | (A*double(d1) > 0)))
e1 = srf_dilate_mask(srf.lh, mask, -1);
assert(isequal(logical(e1(:)), mask & ~(A*double(~mask) > 0)))
assert(all(mask(logical(e1))))

disp('test_srf_dilate_mask: all tests passed')
