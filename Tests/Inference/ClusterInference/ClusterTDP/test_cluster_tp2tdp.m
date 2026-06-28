%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the cluster_tp2tdp function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
tp_bounds = [5, 10, 3];
clusters = {1:8, 1:15, 1:6};
tdp_bounds = cluster_tp2tdp(tp_bounds, clusters);

% Echo the result so the test produces visible output.
disp('tdp_bounds ='); disp(tdp_bounds)
