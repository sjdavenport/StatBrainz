%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the srf_cope_display2 function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Cope sets on the left hemisphere
srf = loadsrf('fs4', 'white');
nv = srf.lh.nvertices;
muhat = srf_noise(srf.lh, 4);
lower_set = muhat + 0.5 > 0;
upper_set = muhat - 0.5 > 0;
c = 0;
srf_cope_display2( srf.lh, lower_set, upper_set, muhat, c );

%% Show the contour of the estimated set instead of the full set
srf_cope_display2( srf.lh, lower_set, upper_set, muhat, c, 0, 1 );

%% Both hemispheres
muhat = srf_noise(srf, 4);
lower_set.lh = muhat.lh + 0.5 > 0; lower_set.rh = muhat.rh + 0.5 > 0;
upper_set.lh = muhat.lh - 0.5 > 0; upper_set.rh = muhat.rh - 0.5 > 0;
srf_cope_display2( srf, lower_set, upper_set, muhat, c );
