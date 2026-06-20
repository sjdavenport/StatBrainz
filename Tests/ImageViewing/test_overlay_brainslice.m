%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the overlay_brainslice function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MNIbrain = imgload('MNIbrain.nii.gz');
MNIbrain = MNIbrain/max(MNIbrain(:));
slice = 45;
overlay_brainslice([0, 0, slice], {MNIbrain > 0.8}, 'red', 0.6)

%%
MNIbrain = imgload('MNIbrain.nii.gz');
MNIbrain = MNIbrain/max(MNIbrain(:));
slice = 45;
overlay_brainslice([0, 0, slice], {NaN}, {NaN}, 1, zero2nan(MNIbrain > 0.8), 1 )

%%
MNIbrain = imgload('MNIbrain.nii.gz');
MNIbrain = MNIbrain/max(MNIbrain(:));
slice = 45;
overlay_brainslice([0, 0, slice], {MNIbrain > 0.8}, {'red'}, 1, [], 1 )
