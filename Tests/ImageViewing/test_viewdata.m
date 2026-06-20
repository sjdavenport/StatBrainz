%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the viewdata function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Brain imaging example
MNImask = imgload('MNImask');
mask2D = MNImask(:,:,50);
% Smoothed random data over the 2D slice (fast_conv stands in for the
% RFTtoolbox field generation used in the original example).
smooth_data = fast_conv(randn(size(mask2D)), 3, 2);
viewdata( smooth_data, mask2D )
viewdata( smooth_data > 0, mask2D )
