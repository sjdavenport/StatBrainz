%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the resample_srf function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

srf6 = loadsrf('fs6', 'sphere');
srf4 = loadsrf('fs4', 'sphere');
data = srf_noise(srf6, 20);

resampled_data = resample_srf(data, srf6, srf4);

subplot(1,2,1)
srfplot(srf6.lh, data.lh)
subplot(1,2,2)
srfplot(srf4.lh, resampled_data.lh)

%%
srf6 = loadsrf('fs7', 'sphere');
srf4 = loadsrf('fs4', 'sphere');
tic
data = srf_noise(srf6, 0);
toc

tic
resampled_data = resample_srf(data, srf6, srf4);
toc

subplot(1,2,1)
srfplot(srf6.lh, data.lh)
subplot(1,2,2)
srfplot(srf4.lh, resampled_data.lh)
