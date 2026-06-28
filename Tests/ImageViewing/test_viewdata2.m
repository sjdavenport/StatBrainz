%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the viewdata2 function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
mask1 = rand(50,50) > 0.5;
mask2 = rand(50,50) > 0.7;
viewdata2({mask1, mask2}, {[1,0,0], [0,0,1]})
fprintf('viewdata2 completed: %d voxels in mask1, %d in mask2\n', nnz(mask1), nnz(mask2));
