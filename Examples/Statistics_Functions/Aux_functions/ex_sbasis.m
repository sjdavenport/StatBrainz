%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the sbasis function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% The 2nd standard basis vector in 4 dimensions
sbasis(2, 4)

%% Move a voxel location one step along the 3rd axis
voxel = [10; 20; 30];
voxel + sbasis(3, 3)

%% Build the identity matrix from the basis vectors
I = [sbasis(1, 3), sbasis(2, 3), sbasis(3, 3)]
