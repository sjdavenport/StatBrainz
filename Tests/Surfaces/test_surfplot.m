%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the surfplot function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Illustration
path4gifti = which('tpl-fsaverage_den-10k_hemi-L_white.surf.gii');
% path4gifti = 'C:\Users\12SDa\Documents\R\win-library\4.1\ciftiTools\extdata\S1200.L.inflated_MSMAll.32k_fs_LR.surf.gii';
data = randn(20480, 1);
surfplot(path4gifti, data)

%%
path4gifti_left = which('tpl-fsaverage_den-10k_hemi-L_white.surf.gii');
X_left = randn(10242*2-4, 1);

subplot(1,2,1)
surfplot(path4gifti_left, X_left(1:10242))
subplot(1,2,2)
surfplot(path4gifti_left, X_left)

