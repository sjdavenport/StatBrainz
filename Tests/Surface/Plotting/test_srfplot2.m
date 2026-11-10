%% test_srfplot2
% Smoke tests of the srfplot2 function (figures are not shown)
%--------------------------------------------------------------------------
rng(1)
srf = loadsrf('fs3', 'white');
data = srf_noise(srf, 10);

%% One hemisphere with data
figure;
srfplot2(srf.lh, data.lh, 0, 0.05, 1, NaN, 0);
close all

%% Default arguments
figure;
srfplot2(srf.lh, data.lh);
close all

%% See the back, other views and no lighting
figure;
srfplot2(srf.rh, data.rh, 1, 0.05, 1, NaN, 0, 0);
for v = {'top', 'back', 'front', 'bottom', 'left', 'right'}
    srfplot2(srf.lh, data.lh, 0, 0.05, 0, v{1}, 0);
end
close all

%% Data on the faces and no data
figure;
srfplot2(srf.lh, randn(srf.lh.nfaces, 1), 0, 0.05, 1, NaN, 0);
srfplot2(srf.lh, [], 0, 0.2, 1, NaN, 0);
close all

%% Both hemispheres
figure;
srfplot2(srf, data, 0, 0.05, 1, NaN, 0);
close all

disp('test_srfplot2: all tests passed')
