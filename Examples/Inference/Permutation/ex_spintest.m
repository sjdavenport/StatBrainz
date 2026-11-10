%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the spin_test function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% prepare workspace
clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Two independent maps on the fs4 surface
srf = loadsrf('fs4', 'white');
srf_sphere = loadsrf('fs4', 'sphere');
gamma = 0;
FWHM = 4;
X = srf_noise(srf, FWHM);
Y = X;
Y.lh = gamma*X.lh + randn(srf.lh.nvertices, 1);
Y.rh = gamma*X.rh + randn(srf.rh.nvertices, 1);
subplot(1,2,1)
srfplot(srf.lh,X.lh)
subplot(1,2,2)
srfplot(srf.lh,Y.lh)

tic
[threshold, rho_store] = spintest( X, Y, srf_sphere, 1000, 0.05, 0 );
toc

%% The threshold is the 1-alpha quantile of the spun correlations
alpha = 0.05;
threshold = prctile(rho_store, 100*(1-alpha) )
rho_store(1) % the correlation of the original (unspun) maps

%% Two correlated maps
Y.lh = X.lh + randn(srf.lh.nvertices, 1);
Y.rh = X.rh + randn(srf.rh.nvertices, 1);
[threshold, rho_store] = spintest( X, Y, srf_sphere, 1000, 0.05, 0 );
threshold
rho_store(1) % this is above the threshold
