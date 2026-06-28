%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the resample_srf_nn function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

srf6 = loadsrf('fs6', 'sphere');
srf4 = loadsrf('fs4', 'sphere');

nnindices = resample_srf_nn( srf6, srf4 );

data = srf_noise(srf6, 20);
resampled_data.lh = data.lh(nnindices.lh);

fprintf('resample_srf_nn: lh has %d nn-indices, range [%d, %d]\n', ...
    numel(nnindices.lh), min(nnindices.lh), max(nnindices.lh));

subplot(1,2,1)
srfplot(srf6.lh, data.lh)
subplot(1,2,2)
srfplot(srf4.lh, resampled_data.lh)