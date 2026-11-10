%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the fgreedy function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Run fgreedy on the example cluster k90.csv
% fgreedy writes its log next to the csv file, so copy the csv file to a
% temporary folder first. The fgreedy binary must be compiled for your
% platform (see ClusterTDPccode).
fgreedy_dir = fileparts(which('fgreedy.c'));
savedir = tempname; mkdir(savedir);
copyfile(fullfile(fgreedy_dir, 'k90.csv'), savedir);
fgreedy(fullfile(savedir, 'k90.csv'), 8, 1)
