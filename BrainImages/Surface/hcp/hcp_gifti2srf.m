sb_dir = statbrainz_maindir;

pathdir = [sb_dir, 'BrainImages/Gifti_files/'];

lh_data = load_gifti([pathdir, 'S1200.L.inflated_MSMAll.32k_fs_LR.surf.gii']);
lh_data.nfaces = size(lh_data.faces,1);
lh_data.nvertices = size(lh_data.vertices,1);
lh_data.hemi = 'lh';

rh_data = load_gifti([pathdir, 'S1200.R.inflated_MSMAll.32k_fs_LR.surf.gii']);
rh_data.nfaces = size(lh_data.faces,1);
rh_data.nvertices = size(lh_data.vertices,1);
rh_data.hemi = 'rh';

clear srf
srf.lh = lh_data;
srf.rh = rh_data;

save('/Users/samd/Documents/Other/MyCode/StatBrainz/BrainImages/Surface/hcp/hcp_32k.mat', 'srf')


%%
a = loadsrf()