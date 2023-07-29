function index = plane2index( plane, extra )
% plane2index(plane) converts a specified 2D plane into a 3D/4D index.
% 
% INPUTS
% plane: a 2D matrix indicating the specific plane to convert into a 4D index
% extra: 0/1 whether to return a 3d or a 4d index
% OUTPUT
% index: a 4D index in the format of {':',':',':',':'} with the specified plane being a fixed axis voxel.
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

if ~exist('extra', 'var')
    extra = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
slice2use = find(plane);
fixed_axis_voxel = plane(slice2use);
if extra == 1
    index = {':',':',':',':'};
else
    index = {':',':',':'};
end
index{slice2use} = fixed_axis_voxel;

end

