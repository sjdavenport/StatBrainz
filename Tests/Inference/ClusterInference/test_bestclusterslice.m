%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the bestclusterslice function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

surviving_cluster_im = zeros(91, 109, 91);
surviving_cluster_im(40:50, 50:60, 40:50) = 1;
% slice_no selects the dimension to scan over (1, 2 or 3)
[maxsumlocs, totalinslice] = bestclusterslice(3, surviving_cluster_im);
maxsumlocs
sum(totalinslice(:))
