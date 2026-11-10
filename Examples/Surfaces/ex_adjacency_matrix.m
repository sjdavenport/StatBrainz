%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the adjacency_matrix function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
srf = loadsrf('fs5', 'white');
srf = srf.lh;
adj_matrix = adjacency_matrix(srf, 'ones');

g = graph(adj_matrix);
cc = conncomp(g)

%%
adj_matrix = adjacency_matrix(srf, 'dist');
disp(full(adj_matrix(1:10,1:10)))

% histogram(data.lh(:))
% surfplot(srf.lh, data.lh)
