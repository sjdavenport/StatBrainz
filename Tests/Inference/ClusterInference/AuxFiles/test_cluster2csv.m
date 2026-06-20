%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the cluster2csv function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cluster = randi(10, 2); % Example 2D cluster
cluster2csv(cluster, 'output_cluster_2d');

cluster = randi(10, 3); % Example 3D cluster
cluster2csv(cluster, 'output_cluster_3d');
