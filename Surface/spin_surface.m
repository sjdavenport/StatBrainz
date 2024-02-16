function [ left_rotations,  right_rotations] = ...
   spin_surface( srf, sphere, nperm, include_orig, show_loader )
% spin_surface implements the Spin Test from Bloch (2018). The function is 
% an adaption of the original code used in Bloch (2018). It uses knnsearch 
% instead of the Nearest Neighbours function used in the original code. 
% This results in a ~200x speed up. We also include an option to include the
% original permutation among the permutations which is necessary for valid inference.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory:
%   srf   a surface structure such that srf.lh.data is the data for the left
%         hemisphere and srf.rh.data is the data for the right hemisphere.
%   sphere   a surface structure such that sphere.lh.vertices and sphere.lh.faces
%            are the vertices and faces of the sphere for the left
%            hemisphere and similarly for the right hemisphere.
% Optional:
%   nperm - Number of permutations (default is 1000).
%   include_orig  0/1 - whether to include the original permutation or not
%   show_loader - Flag for displaying progress (default is 1).
%--------------------------------------------------------------------------
% OUTPUT
%   left_rotations - Rotated data from the left hemisphere.
%   right_rotations - Rotated data from the right hemisphere.
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
% Copyright (C) - 2018 - Alexander-Bloch 
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist('include_orig', 'var')
    include_orig = 1;
end

if ~exist('show_loader', 'var')
    show_loader = 1;
end

if ~exist( 'nperm', 'var' )
   % Default value
   nperm = 1000;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
if ~exist('sphere', 'var')
    %Read sphere surface coordinates using SurfStat
    filename='C:\Users\12SDa\davenpor\davenpor\Toolboxes\BrainStat\BrainImages\sphere.obj';
    surf = SurfStatReadSurf(filename);
    vertices_left = surf.coord'; vertices_right = surf.coord';
else
    vertices_left = sphere.lh.vertices;
    vertices_right = sphere.rh.vertices;
end

rng(0);
%Use rng to initialize the random generator for reproducible results.

% Initialize matrices to store the rotated data
% left_rotations = zeros(length(leftdata), nperm);
if include_orig
    left_rotations = srf.lh.data';
    right_rotations = srf.rh.data';
else
    left_rotations = [];
    right_rotations = [];
end

% Set the 3x3 reflection matrix to reflect between hemispheres.
reflection_matrix = eye(3,3);
reflection_matrix(1,1)= -1;

% Initialize the vertices to be rotated
bl = vertices_left;
br = vertices_right;

% Run the Permutation
for j = 2:nperm
    if show_loader == 1
        loader(j-1, nperm-1, 'spin_surface progress:');
    end
    % Run uniform sampling
    A = normrnd(0,1,3,3);
    [TL, temp] = qr(A);
    TL = TL * diag(sign(diag(temp)));
    if(det(TL)<0)
        TL(:,1) = -TL(:,1);
    end
    %reflect across the Y-Z plane for right hemisphere
    TR = reflection_matrix * TL * reflection_matrix;
    bl = bl*TL;
    br = br*TR;   
    
    %Find the pair of matched vertices with the min distance and reassign
    %values to the rotated surface. Using knnsearch here as opposed to
    % the Nearest Neighbours code used in the original code is much faster
    rotation_idx = knnsearch(bl, vertices_left);
    
    % Store the rotated data
    left_rotations = [left_rotations; srf.lh.data(rotation_idx)'];
    right_rotations = [right_rotations; srf.rh.data(rotation_idx)'];
end

left_rotations = left_rotations';
right_rotations = right_rotations';

end

