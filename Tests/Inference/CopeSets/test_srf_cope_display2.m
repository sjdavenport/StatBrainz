% Tests for srf_cope_display2 (a plotting function: smoke tests)

srf = loadsrf('fs4', 'white');
rng(38)
muhat = srf_noise(srf, 4);
c = 0;

%% One hemisphere runs
figure;
srf_cope_display2(srf.lh, muhat.lh + 0.5 > c, muhat.lh - 0.5 > c, muhat.lh, c);
close all

%% Contour without interpolation runs
figure;
srf_cope_display2(srf.lh, muhat.lh + 0.5 > c, muhat.lh - 0.5 > c, muhat.lh, c, 0, 1, 0);
close all

%% Both hemispheres run
lower_set.lh = muhat.lh + 0.5 > c; lower_set.rh = muhat.rh + 0.5 > c;
upper_set.lh = muhat.lh - 0.5 > c; upper_set.rh = muhat.rh - 0.5 > c;
figure;
srf_cope_display2(srf, lower_set, upper_set, muhat, c);
close all

%% The output out can be requested
figure;
out = srf_cope_display2(srf.lh, lower_set.lh, upper_set.lh, muhat.lh, c);
close all
