%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the viewbrain function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MNIbrain = imgload('MNIbrain.nii.gz');
MNIbrain = MNIbrain/max(MNIbrain(:));
viewbrain(MNIbrain.*(MNIbrain> 0.8), [30,40,50]);
viewbrain(MNIbrain.*(MNIbrain> 0.8)/max(MNIbrain(:)), [30,40,50]);
fprintf('viewbrain completed on volume of size [%s]\n', num2str(size(MNIbrain)));
