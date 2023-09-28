%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the surfplot function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% prepare workspace
clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Illustration
path4gifti = 'C:\Users\12SDa\Documents\R\win-library\4.1\ciftiTools\extdata\S1200.L.inflated_MSMAll.32k_fs_LR.surf.gii';
surfplot(path4gifti)
set(gcf, 'position', [17.6667   41.6667  856.6667  599.3333])
