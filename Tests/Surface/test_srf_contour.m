%% test_srf_contour
% Tests of the srf_contour function
%--------------------------------------------------------------------------
% Octahedron: 6 vertices, 8 faces, each vertex has 4 neighbours
% (vertex 1 is next to 3, 4, 5, 6 but not to 2)
oct.vertices = [1 0 0; -1 0 0; 0 1 0; 0 -1 0; 0 0 1; 0 0 -1];
oct.faces = [1 3 5; 3 2 5; 2 4 5; 4 1 5; 3 1 6; 2 3 6; 4 2 6; 1 4 6];
oct.nvertices = 6;
oct.nfaces = 8;

%% One vertex: it is the inner contour, its neighbours the outer contour
mask = logical([1 0 0 0 0 0]');
[inner, outer] = srf_contour(oct, mask);
assert(isequal(logical(inner(:)), logical([1 0 0 0 0 0]')))
assert(isequal(logical(outer(:)), logical([0 0 1 1 1 1]')))

%% All but one vertex
mask = logical([1 0 1 1 1 1]');
[inner, outer] = srf_contour(oct, mask);
assert(isequal(logical(inner(:)), logical([0 0 1 1 1 1]')))
assert(isequal(logical(outer(:)), logical([0 1 0 0 0 0]')))

%% Restrict to an adjacent set
mask = logical([1 0 0 0 0 0]');
adj = logical([0 0 1 0 0 0]');
[inner, outer] = srf_contour(oct, mask, adj);
assert(isequal(logical(inner(:)), logical([1 0 0 0 0 0]')))
assert(isequal(logical(outer(:)), logical([0 0 1 0 0 0]')))
adj = logical([0 1 0 0 0 0]');
[inner, outer] = srf_contour(oct, mask, adj);
assert(~any(inner) && ~any(outer))

%% On a surface: inner is in the mask, outer is outside
rng(1)
srf = loadsrf('fs3', 'sphere');
mask = srf_noise(srf.lh, 10) > 0;
[inner, outer] = srf_contour(srf.lh, mask);
inner = logical(inner); outer = logical(outer);
assert(all(mask(inner)))
assert(~any(mask(outer)))
assert(any(inner) && any(outer))
A = adjacency_matrix(srf.lh);
assert(isequal(outer(:), ~mask & (A*double(mask) > 0)))
assert(isequal(inner(:), mask & (A*double(~mask) > 0)))

%% Both hemispheres
clear maskb
maskb.lh = mask;
maskb.rh = ~mask;
[inner, outer] = srf_contour(srf, maskb);
assert(isfield(inner, 'lh') && isfield(outer, 'rh'))
[il, ol] = srf_contour(srf.lh, maskb.lh);
[ir, orr] = srf_contour(srf.rh, maskb.rh);
assert(isequal(inner.lh, il) && isequal(outer.lh, ol))
assert(isequal(inner.rh, ir) && isequal(outer.rh, orr))

disp('test_srf_contour: all tests passed')
