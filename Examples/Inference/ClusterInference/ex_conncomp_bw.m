%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the conncomp_bw function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 2D: connected components of a binary image
mask = zeros(10,10);
mask(2,2) = 1;
mask(5:8, 5:8) = 1;
CC = conncomp_bw( mask );
CC.NumObjects
cellfun(@numel, CC.PixelIdxList)

%% 2D: connectivity 4 versus 8
mask = zeros(6,6);
mask(2,2) = 1; mask(3,3) = 1; mask(4,4) = 1;   % voxels on a diagonal
CC8 = conncomp_bw( mask, 8 );
CC4 = conncomp_bw( mask, 4 );
fprintf('Diagonal voxels: %d component(s) with connectivity 8, %d with connectivity 4\n', ...
    CC8.NumObjects, CC4.NumObjects);

%% 3D: clusters of thresholded smooth noise
rng(1)
dim = [30,30,30];
noise = fast_conv( randn(dim), 4, 3 );
noise = noise/std(noise(:));
CC = conncomp_bw( noise > 2, 26 );
sizes = cellfun(@numel, CC.PixelIdxList);
fprintf('%d clusters above 2, the largest has %d voxels\n', CC.NumObjects, max([0, sizes]));
% Show the largest cluster
cluster_mask = zeros(dim);
[~, largest] = max(sizes);
cluster_mask(CC.PixelIdxList{largest}) = 1;
imagesc(squeeze(max(cluster_mask, [], 3))); axis image off
