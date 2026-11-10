%% test_srfplot
% Smoke tests of the srfplot function (figures are not shown)
%--------------------------------------------------------------------------
rng(1)
srf = loadsrf('fs3', 'white');
data = srf_noise(srf, 10);

%% One hemisphere with data
figure;
srfplot(srf.lh, data.lh, NaN, 1, 0.05, 0);
close all

%% Default arguments
figure;
srfplot(srf.lh, data.lh);
close all

%% View strings and numbers
for v = {'side', 'backside', 'top', 'back', 'front', 'bottom', 'left', 'right'}
    figure;
    srfplot(srf.rh, data.rh, v{1}, 1, 0.05, 0);
    close all
end
figure;
srfplot(srf.lh, data.lh, 1, 0, 0.1, 0, 0);
srfplot(srf.lh, data.lh, [45, 30], 1, 0.1, 0);
close all

%% Data on the faces
figure;
srfplot(srf.lh, randn(srf.lh.nfaces, 1), 'side', 0, 0.05, 0);
close all

%% No data: the empty mesh
figure;
srfplot(srf.lh, [], 'side', 0, 0.25, 0);
close all

%% Both hemispheres
figure;
srfplot(srf, data, 'top', 0, 0.05, 0);
close all

%% All four views
figure;
srfplot(srf, data, 'all');
close all

%% Both hemispheres without data
figure;
srfplot(srf);
close all

disp('test_srfplot: all tests passed')
