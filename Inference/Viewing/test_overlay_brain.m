%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the overlay_brain function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Illustration on the MNIbrain!
MNIbrain = imgload('MNIbrain.nii.gz');
MNIbrain = MNIbrain/max(MNIbrain(:));
overlay_brain([30,40,50], {MNIbrain > 0.8}, {'red'}, 0.6, 4)