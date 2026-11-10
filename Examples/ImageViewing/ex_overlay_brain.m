%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the overlay_brain function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% View the MNI brain in three planes
overlay_brain([30,40,50]);

%% Overlay a region in red
MNIbrain = imgload('MNIbrain.nii.gz');
MNIbrain = MNIbrain/max(MNIbrain(:));
overlay_brain([30,40,50], {MNIbrain > 0.8}, {'red'}, 0.6);

%% Show data (NaN outside the region) on top of the 1mm MNI brain
underim = zero2nan(MNIbrain.*(MNIbrain > 0.8));
overlay_brain([30,40,50], {MNIbrain > 0.9}, {'blue'}, 1, underim, 1);
