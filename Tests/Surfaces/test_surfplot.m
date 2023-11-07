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


%%
path4gifti_left = 'C:/Users/12SDa/davenpor/davenpor/Toolboxes/BrainStat/BrainImages/Gifti_files/tpl-fsaverage_den-10k_hemi-L_white.surf.gii';

X_left = randn(10242*2-4, 1);

subplot(1,2,1)
surfplot(path4gifti_left, X_left(1:10242))
subplot(1,2,2)
surfplot(path4gifti_left, X_left)

