% Define the directory
dir_data = '/Users/sdavenport/Documents/Code/R/BayesfMRI/vignette_data/sub1/session1';

% Construct file paths
fname_BOLD = fullfile(dir_data, 'BOLD_10k.dtseries.nii');
fname_motion = fullfile(dir_data, 'Movement_Regressors.txt');

% Construct event file paths
fname_events = {fullfile(dir_data, 'EVs', 'fear.txt'), ...
                fullfile(dir_data, 'EVs', 'neut.txt')};

%%
data_all = niftiread(fname_BOLD);
data_all = squeeze(data_all)';

lh_data = data_all(1:9394, :);
rh_data = data_all(9395:(9394+9398), :);

%% Put the data on the surface (if desired)
addpath(genpath('/Users/sdavenport/Documents/Code/MATLAB/Other_Toolboxes/cifti-matlab'))
a = cifti_read(fname_BOLD);
a.diminfo{1}.models{1}
clear data
data.lh = zeros(10242, size(lh_data,2));
data.lh(a.diminfo{1}.models{1}.vertlist+1, :) = lh_data;
data.rh = zeros(10242, size(rh_data,2));
data.rh(a.diminfo{1}.models{2}.vertlist+1, :) = rh_data;

%%
srf = loadsrf('fs5', 'inflated');
srfplot(srf.lh, data.lh(:,100))
colormap('spring')

%%
motion = readmatrix(fname_motion);
imagesc(motion)
colormap('winter')

%%
events1 = readmatrix(fname_events{1});
events2 = readmatrix(fname_events{2});

%%
