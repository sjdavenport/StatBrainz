function face_areas = surf_face_area( path4gifti )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
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
g = gifti(path4gifti);
vertices = g.vertices;
faces = g.faces;

% Initialize an array to store the areas of each face
face_areas = zeros(size(faces, 1), 1);

%%  Main Function Loop
%--------------------------------------------------------------------------
for i = 1:size(faces, 1)
    % Get the vertices of the current face
    vertex_indices = faces(i, :);
    vertices_face = vertices(vertex_indices, :);
    
    % Calculate the vectors representing two sides of the triangle
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

