%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the graph_cc function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
srf = loadsrf('fs5', 'white');
data = srf_noise(srf, 20);
thresh = 0.02;
survived = data.lh > thresh;
% notsurvived = data.lh < 0.02;

srfplot(srf.lh, survived)
% indices = 1:srf.lh.nvertices;
% indices_notsurvived = indices(notsurvived);
adj_matrix = adjacency_matrix(srf.lh);

[ number_of_clusters, occurences, cluster_sizes, index_locations ]  = ...
                                graph_cc( data.lh, thresh, adj_matrix );

%%
new_adj_matrix = adj_matrix;
new_adj_matrix(indices_notsurvived,:) = 0;
new_adj_matrix(:,indices_notsurvived) = 0;

g = graph(new_adj_matrix);
[cc, binsizes] = conncomp(g);
