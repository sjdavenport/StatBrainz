%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the extract_brain function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% extract_brain needs HD-BET and python on your own computer (the paths are
% set inside the function). With runnet = 0 it only prints the command.

%% Print the HD-BET command for a NIfTI file
filename = [statbrainz_maindir, 'BrainImages/Volume/MNIbrain.nii.gz'];
extract_brain( filename, 0, 0 )

%% Print the HD-BETplay command
extract_brain( filename, 1, 0 )

%% Run HD-BET (this needs HD-BET to be installed)
% extract_brain( filename )
