%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the gifti2surf function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gifti_dir = [statbrainz_maindir, 'BrainImages/Gifti_files/'];

%% Single hemisphere
srf = gifti2surf([gifti_dir, 'lh_10242.gii']);
srf.nvertices
srf.nfaces

%% Both hemispheres
srf = gifti2surf([gifti_dir, 'lh_10242.gii'], [gifti_dir, 'rh_10242.gii']);
srf.lh.nvertices
srf.rh.nvertices
srf.lh.hemi
srf.rh.hemi
