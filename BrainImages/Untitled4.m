% Load the 3D mask data from a saved file
mask = image;

% Create a 3D grid of coordinates for the mask
[x,y,z] = meshgrid(1:size(mask,2), 1:size(mask,1), 1:size(mask,3));

% Plot the mask as a 3D isosurface
isosurface(x, y, z, mask, 0.5);

% Set plot properties
colormap(cool);
axis equal;
view(3);
axis off
camlight;
lighting gouraud;

% for I = 1:360
%     view(I,0)
%     pause(0.01)
% end

rotate3d on
