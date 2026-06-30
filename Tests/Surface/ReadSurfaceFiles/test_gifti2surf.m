%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the gifti2surf function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% BLOCKED: gifti2surf calls the third-party `gifti` reader, which is not on
% the path in this environment (not bundled with StatBrainz). Install the
% gifti toolbox to run this. Bundled .gii files exist under
% BrainImages/Gifti_files/ (e.g. lh_10242.gii, rh_10242.gii).
% gifti_dir = [statbrainz_maindir, 'BrainImages/Gifti_files/'];
% srf = gifti2surf([gifti_dir, 'lh_10242.gii']);
% srf = gifti2surf([gifti_dir, 'lh_10242.gii'], [gifti_dir, 'rh_10242.gii']);
