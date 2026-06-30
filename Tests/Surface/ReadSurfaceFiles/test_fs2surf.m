%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the fs2surf function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

srf_dir = [statbrainz_maindir, 'BrainImages/Surface/'];

% Single hemisphere
srf = fs2surf([srf_dir, 'fs5.lh.white']);
srf.nvertices
srf.nfaces

%%
% Both hemispheres
srf = fs2surf([srf_dir, 'fs5.lh.white'], [srf_dir, 'fs5.rh.white']);
srf.lh.nvertices
srf.rh.nvertices
