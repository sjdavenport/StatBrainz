%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the bayespw function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NB: the function in bayespw.m is called GLM_est_resid_var_pw. MATLAB
% uses the file name, so call it as bayespw.

%% Residual variance for one session, no prewhitening
nT = 100; nV = 50;
BOLD = {randn(nT, nV)};
design = {randn(nT, 3)};
spatial = randn(5, nV);
results = bayespw(BOLD, design, spatial, {'session1'}, ...
    {'task1', 'task2', 'task3'}, 'regular', true(1, 3), nT, 6, 0, 0, 1, 0);
results.var_avg(1:5)'

%% Two sessions, the variances are averaged across sessions
BOLD = {randn(nT, nV), 2*randn(nT, nV)};
design = {randn(nT, 3), randn(nT, 3)};
results = bayespw(BOLD, design, spatial, {'session1', 'session2'}, ...
    {'task1', 'task2', 'task3'}, 'regular', true(2, 3), nT, 6, 0, 0, 1, 0);
size(results.var_resid)

%% A separate design at each data location
BOLD = {randn(nT, nV)};
design = {randn(nT, 3, nV)};
results = bayespw(BOLD, design, spatial, {'session1'}, ...
    {'task1', 'task2', 'task3'}, 'per_location', true(1, 3), nT, 6, 0, 0, 1, 0);
size(results.sqrtInv_all{1})
