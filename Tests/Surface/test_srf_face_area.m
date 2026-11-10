%% test_srf_face_area
% Tests of the srf_face_area function
%--------------------------------------------------------------------------
% Octahedron: 6 vertices, 8 faces, each vertex has 4 neighbours
oct.vertices = [1 0 0; -1 0 0; 0 1 0; 0 -1 0; 0 0 1; 0 0 -1];
oct.faces = [1 3 5; 3 2 5; 2 4 5; 4 1 5; 3 1 6; 2 3 6; 4 2 6; 1 4 6];
oct.nvertices = 6;
oct.nfaces = 8;

%% Octahedron: every face is equilateral with side sqrt(2)
[fa, va] = srf_face_area(oct);
assert(isequal(size(fa), [8, 1]))
assert(isequal(size(va), [6, 1]))
assert(max(abs(fa - sqrt(3)/2)) < 1e-12)
% each vertex is in 4 faces and gets a third of each
assert(max(abs(va - 4*(sqrt(3)/2)/3)) < 1e-12)

%% A single right angled triangle
clear tri
tri.vertices = [0 0 0; 3 0 0; 0 4 0];
tri.faces = [1 2 3];
tri.nvertices = 3;
tri.nfaces = 1;
[fa, va] = srf_face_area(tri);
assert(abs(fa - 6) < 1e-12)
assert(max(abs(va - 2)) < 1e-12)

%% Vertex areas sum to the total area
srf = loadsrf('fs4', 'white');
[fa, va] = srf_face_area(srf.lh);
assert(numel(fa) == srf.lh.nfaces)
assert(numel(va) == srf.lh.nvertices)
assert(all(fa > 0))
assert(abs(sum(va) - sum(fa)) < 1e-6*sum(fa))

%% The fs4 sphere has area close to 4*pi*100^2
srf = loadsrf('fs4', 'sphere');
fa = srf_face_area(srf.lh);
assert(sum(fa) < 4*pi*100^2)
assert(sum(fa) > 0.99*4*pi*100^2)

%% A struct with only faces and vertices
clear tri2
tri2.vertices = tri.vertices;
tri2.faces = tri.faces;
[fa, va] = srf_face_area(tri2);
assert(abs(fa - 6) < 1e-12)
assert(max(abs(va - 2)) < 1e-12)

%% A path to a gifti file
srf5 = loadsrf('fs5', 'white');
fa5 = srf_face_area(srf5.lh);
path4gifti = [statbrainz_maindir, 'BrainImages/Gifti_files/lh_10242.gii'];
[fa, va] = srf_face_area(path4gifti);
assert(max(abs(fa - fa5)) < 1e-6)
assert(numel(va) == 10242)

disp('test_srf_face_area: all tests passed')
