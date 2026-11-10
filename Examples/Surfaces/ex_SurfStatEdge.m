%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the SurfStatEdge function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
path4gifti = 'C:/Users/12SDa/neuromaps-data/atlases/fsaverage/tpl-fsaverage_den-10k_hemi-L_white.surf.gii';
srf = gifti2surf(path4gifti);
edg = SurfStatEdg( srf );
adj_matrix = adjacency_matrix(srf, 'dist');
