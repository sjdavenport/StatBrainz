%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the ctp_scores function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Collect the fgreedy results of several clusters
% clustertdp(clusters, threshold, 'heuristic', logdir) writes the folders
% logdir/cluster_1, logdir/cluster_2, ... and runs fgreedy in each. Here
% the fgreedy.log files are written by hand.
logdir = tempname;
scores = [12, 3, 25];
for I = 1:length(scores)
    cluster_dir = fullfile(logdir, ['cluster_', num2str(I)]);
    mkdir(cluster_dir);
    fid = fopen(fullfile(cluster_dir, 'fgreedy.log'), 'w');
    fprintf(fid, 'minscore=%d time=0.5\n', scores(I) + 5);
    fprintf(fid, 'minscore=%d time=1.0\n', scores(I));
    fprintf(fid, 'totaltime_sec:1.2\n');
    fclose(fid);
end
tp_bounds = ctp_scores(logdir)

%% A cluster whose computation is still running
fid = fopen(fullfile(logdir, 'cluster_2', 'fgreedy.log'), 'w');
fprintf(fid, 'minscore=4 time=0.5\n');
fclose(fid);
tp_bounds = ctp_scores(logdir)

%% Convert the true positive bounds to TDP bounds
cluster_sizes = [40, 10, 60];
clusters = arrayfun(@(n) (1:n)', cluster_sizes, 'UniformOutput', false);
tdp_bounds = cluster_tp2tdp(tp_bounds, clusters)
rmdir(logdir, 's');
