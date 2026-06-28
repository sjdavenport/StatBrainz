%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the cluster2csv function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cluster = randi(10, 2); % Example 2D cluster
cluster2csv(cluster, 'output_cluster_2d');

cluster = randi(10, 3); % Example 3D cluster
cluster2csv(cluster, 'output_cluster_3d');

% Echo a summary so the test produces visible output.
fprintf('cluster2csv wrote: %s, %s\n', ...
    'output_cluster_2d', 'output_cluster_3d');
fprintf('2D csv exists: %d, 3D csv exists: %d\n', ...
    isfile('output_cluster_2d.csv'), isfile('output_cluster_3d.csv'));
