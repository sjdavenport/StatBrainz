function tp_bounds = ctp_scores( logdir )
% CTP_SCORES reads fgreedy log files from a directory and returns the true
% positive lower bounds for each cluster.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  logdir   path to the directory containing per-cluster fgreedy log
%           subdirectories (each must contain a 'fgreedy.log' file)
%--------------------------------------------------------------------------
% OUTPUT
% tp_bounds   a vector of true positive lower bounds, one per cluster
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
% Read the clusters in numeric order: filesindir sorts alphabetically
% (cluster_1, cluster_10, cluster_2, ...)
cluster_names = filesindir(logdir);
nclusters = sum(~cellfun(@isempty, regexp(cluster_names, '^cluster_\d+$')));
tp_bounds = zeros(1, nclusters);
for I = 1:nclusters
    cluster_name = ['cluster_', num2str(I)];
    [tp_bounds(I), ~, hasfinished] = ctp_extract_score(fullfile(logdir, cluster_name, 'fgreedy.log'));
    if ~hasfinished
        fprintf(['The computation for ', cluster_name, ' is still in progress\n'])
    end
end

end

