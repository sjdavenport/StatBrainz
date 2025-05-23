%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the adjacency_matrix function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
path4gifti = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_white.surf.gii';
srf = gifti2surf(path4gifti);
adj_matrix = adjacency_matrix(srf, 'ones');

g = graph(adj_matrix);
cc = conncomp(g)

%%
adj_matrix = adjacency_matrix(srf, 'dist');
disp(adj_matrix)

% histogram(data.lh(:))
% surfplot(srf.lh, data.lh)
