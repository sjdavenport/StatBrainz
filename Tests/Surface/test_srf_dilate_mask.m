%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srf_dilate_mask function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Positive dilation
srf = loadsrf('fs5', 'sphere')
data = randn(srf.lh.nvertices,1);
mask = smooth_surface(srf.lh, data, 20) > 0;
dilated_mask = srf_dilate_mask(srf.lh, mask, 1);
subplot(1,2,1)
srfplot(srf.lh, mask); title('Original Mask')
subplot(1,2,2)
srfplot(srf.lh, dilated_mask); title('Dilated Mask')

%% Negative dilation
srf = loadsrf('fs5', 'sphere')
data = randn(srf.lh.nvertices,1);
mask = smooth_surface(srf.lh, data, 20) > 0;
dilated_mask = srf_dilate_mask(srf.lh, mask, -1);
subplot(1,2,1)
srfplot(srf.lh, mask); title('Original Mask')
subplot(1,2,2)
srfplot(srf.lh, dilated_mask); title('Dilated Mask')
