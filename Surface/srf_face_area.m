function face_areas = srf_face_area( srf )
% surf_face_area computes the area of each face on a given surface
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% path4surf   a path to a file storing the geometry information, gifti and
%             freesurfer paths are accepted. A structure g containing
%             g.faces and a g.vertices entries can also be used here.
%--------------------------------------------------------------------------
% OUTPUT
% face_areas    a vector giving the area of each face
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if isstruct(srf)
    vertices = srf.vertices;
    faces = srf.faces;
elseif strcmp(srf(end-3:end), '.gii')
    g = gifti(srf);
    vertices = g.vertices;
    faces = g.faces;
else
    [vertices, faces] = read_fs_geometry(srf);
end


% Initialize an array to store the areas of each face
face_areas = zeros(size(faces, 1), 1);

%%  Main Function Loop
%--------------------------------------------------------------------------
for i = 1:size(faces, 1)
    % Get the vertices of the current face
    vertex_indices = faces(i, :);
    vertices_face = vertices(vertex_indices, :);
    
    % Calculate vectors representing two sides of the triangle
    side1 = vertices_face(2, :) - vertices_face(1, :);
    side2 = vertices_face(3, :) - vertices_face(1, :);
    
    % Calculate the cross product of the two sides
    cross_product = cross(side1, side2);
    
    % Calculate the area of the triangle
    area = 0.5 * norm(cross_product);
    
    % Store the area in the array
    face_areas(i) = area;
end

end

