%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the read_gifti function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gifti_dir = [statbrainz_maindir, 'BrainImages/Gifti_files/'];

%% Read a GZipBase64Binary surface file
g = read_gifti([gifti_dir, 'lh_10242.gii']);
size(g.vertices)        % expect [10242 3]
size(g.faces)           % expect [20480 3]
g.vertices(1,:)         % expect [-36.7855 -18.6004 64.8213]
g.faces(1,:)            % expect [1 2565 2563] (0-based [0 2564 2562] + 1)

%% Faces are 1-based and index every vertex
assert(min(g.faces(:)) == 1, 'faces should be 1-based')
assert(max(g.faces(:)) == size(g.vertices,1), 'max face index should equal nvertices')

%% Vertices and faces are numeric doubles
assert(isa(g.vertices, 'double') && size(g.vertices,2) == 3)
assert(isa(g.faces, 'double') && size(g.faces,2) == 3)

%% mat defaults to identity when no transform is present
isequal(g.mat, eye(4))  % expect 1

%% A 32k HCP surface reads with the expected sizes
g2 = read_gifti([gifti_dir, 'S1200.L.inflated_MSMAll.32k_fs_LR.surf.gii']);
size(g2.vertices)       % expect [32492 3]
size(g2.faces)          % expect [64980 3]

%% read_gifti and gifti2surf agree
srf = gifti2surf([gifti_dir, 'lh_10242.gii']);
assert(isequal(srf.vertices, g.vertices))
assert(isequal(srf.faces, g.faces))
assert(srf.nvertices == size(g.vertices,1))
assert(srf.nfaces == size(g.faces,1))

disp('read_gifti: all checks passed')
