%% test_adjacency_matrix
% Tests of the adjacency_matrix function
%--------------------------------------------------------------------------
% Octahedron: 6 vertices, 8 faces, each vertex has 4 neighbours
% (vertex 1 is next to 3, 4, 5, 6 but not to 2)
oct.vertices = [1 0 0; -1 0 0; 0 1 0; 0 -1 0; 0 0 1; 0 0 -1];
oct.faces = [1 3 5; 3 2 5; 2 4 5; 4 1 5; 3 1 6; 2 3 6; 4 2 6; 1 4 6];
oct.nvertices = 6;
oct.nfaces = 8;

%% Default metric gives ones on the edges
A = adjacency_matrix(oct);
assert(issparse(A))
assert(isequal(size(A), [6, 6]))
assert(isequal(A, A'))
assert(nnz(A) == 24)            % 12 edges, both directions
assert(all(full(sum(A, 2)) == 4))
assert(A(1,2) == 0 && A(1,3) == 1 && A(1,1) == 0)
assert(isequal(A, adjacency_matrix(oct, 'ones')))

%% The dist metric gives the edge lengths
D = adjacency_matrix(oct, 'dist');
assert(isequal(D ~= 0, A ~= 0))
assert(max(abs(nonzeros(D) - sqrt(2))) < 1e-12)
assert(isequal(D, adjacency_matrix(oct, 'distance')))

%% Compare dist with the vertex coordinates on a surface
srf = loadsrf('fs3', 'white');
D = adjacency_matrix(srf.lh, 'dist');
[i, j, d] = find(D);
V = double(srf.lh.vertices);
assert(max(abs(d - sqrt(sum((V(i,:) - V(j,:)).^2, 2)))) < 1e-4)

%% Number of edges on a closed triangle mesh
A = adjacency_matrix(srf.lh);
assert(nnz(A) == 3*srf.lh.nfaces)    % edges = 3*nfaces/2
assert(isequal(size(A), [srf.lh.nvertices, srf.lh.nvertices]))
% every edge of every face is in the matrix
F = srf.lh.faces;
assert(all(full(A(sub2ind(size(A), F(:,1), F(:,2)))) == 1))
assert(all(full(A(sub2ind(size(A), F(:,2), F(:,3)))) == 1))

disp('test_adjacency_matrix: all tests passed')
