%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the getlargestcluster function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mask = zeros(10,10);
mask(2,2) = 1;
mask(5:8, 5:8) = 1;
clustermask = getlargestcluster(mask);
fprintf('getlargestcluster: %d voxels in input -> %d voxels in largest cluster\n', ...
    nnz(mask), nnz(clustermask));
imagesc(clustermask)
