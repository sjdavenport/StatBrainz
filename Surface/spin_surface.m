function [ left_rotations,  right_rotations] = ...
   spin_surface( leftdata, rightdata, spherepathloc, nperm, show_loader )
% spin_surface implements the Spin Test from Bloch (2018). The function is 
% an adaption of the original code used in Bloch (2018). It uses knnsearch 
% instead of the Nearest Neighbours function used in the original code. 
% This results in a 200x speed up in the code. We also include the 
% original permutation among the permutations which is necessary for valid 
% inference.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory:
%   leftdata - Data from the left hemisphere.
%   rightdata - Data from the right hemisphere.
%
% Optional:
%   spherepathloc  -  a string giving the location of a gifti sphere object
%   nperm - Number of permutations (default is 1000).
%   show_loader - Flag for displaying progress (default is 1).
%--------------------------------------------------------------------------
% OUTPUT
%   left_rotations - Rotated data from the left hemisphere.
%   right_rotations - Rotated data from the right hemisphere.
%--------------------------------------------------------------------------
% EXAMPLES
% readleft = 'C:\Users\12SDa\davenpor\davenpor\Other_Toolboxes\spin-test\data\ptsdCIVETdataL.csv';
% readright = 'C:\Users\12SDa\davenpor\davenpor\Other_Toolboxes\spin-test\data\ptsdCIVETdataR.csv';
% leftdata = importdata(readleft);
% rightdata = importdata(readright);
% [ bigrotl,  bigrotr] = spintest( leftdata, rightdata, 100 );
%--------------------------------------------------------------------------
% AUTHOR: Alexander-Bloch and Samuel Davenport
%--------------------------------------------------------------------------

if ~exist('show_loader', 'var')
    show_loader = 1;
end

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'nperm', 'var' )
   % Default value
   nperm = 1000;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
if ~exist('spherepathloc', 'var')
    %Read sphere surface coordinates using SurfStat
    filename='C:\Users\12SDa\davenpor\davenpor\Toolboxes\BrainStat\BrainImages\sphere.obj';
    surf = SurfStatReadSurf(filename);
    vertices_left = surf.coord'; vertices_right = surf.coord';
else
    sphere_data = gifti(spherepathloc);
    vertices_left = sphere_data.vertices;
    vertices_right = sphere_data.vertices;
end

rng(0);
%Use rng to initialize the random generator for reproducible results.

% Initialize matrices to store the rotated data
% left_rotations = zeros(length(leftdata), nperm);
left_rotations = leftdata';
right_rotations = rightdata';

% Set the 3x3 reflection matrix to reflect between hemispheres.
reflection_matrix = eye(3,3);
reflection_matrix(1,1)= -1;

% Initialize the vertices to be rotated
bl = vertices_left;
br = vertices_right;

% Run the Permutation
for j = 2:nperm
    if show_loader == 1
        loader(j-1, nperm-1, 'spin test progress:');
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
    left_rotations = [left_rotations; leftdata(rotation_idx)'];
    right_rotations = [right_rotations; rightdata(rotation_idx)'];
end

left_rotations = left_rotations';
right_rotations = right_rotations';

end

