%% test_srfgui
% Smoke test of the srfgui function (at the moment it is a stub)
%--------------------------------------------------------------------------
rng(1)
srf = loadsrf('fs3', 'white');
data = srf_noise(srf.lh, 10);

%% The call runs
figure;
srfgui(srf.lh, data);
close all

disp('test_srfgui: all tests passed')
