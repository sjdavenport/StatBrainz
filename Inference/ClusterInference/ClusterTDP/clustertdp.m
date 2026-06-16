function [ tdp_bounds, tp_bounds ] = clustertdp( clusters, cluster_threshold, method, savedir )
% CLUSTERTDP( clusters, cluster_threshold ) calculates lower bounds for the  
% true discovery proportion (TDP) and true positives (TP) within each
% cluster found signficant after performing clustersize inference.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory:
% - clusters: Cell array where each entry is a matrix of [x,y,z] coordinates
%             for a significant cluster
% - cluster_threshold: an integer giving the cluster-size threshold obtained
%                      from clustersize inference
% Optional:
% - method: 'lowerbound' (default) computes an analytic lower bound;
%           'heuristic' or 'greedy' dispatches the fgreedy algorithm
% - savedir: directory to store fgreedy input/output (default: './')
%--------------------------------------------------------------------------
% OUTPUT
% - tdp_bounds: Array giving the TDP lower bounds for each cluster.
% - tp_bounds: Array of TP lower bounds for each cluster.
%--------------------------------------------------------------------------
% EXAMPLES
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'savedir', 'var' )
   % Default value
   savedir = './';
end

if ~exist('savedir', 'var')
    savedir = './';
end

if ~exist('method', 'var')
    method = 'lowerbound';
end

%%  Main Function Loop
%--------------------------------------------------------------------------
if strcmp(method, 'lowerbound')
tp_bounds = zeros(1, length(clusters));
tdp_bounds = zeros(1, length(clusters));
else
    tp_bounds = NaN;
    tdp_bounds = NaN;
end

if strcmp(method, 'heuristic')
    if ~exist('savedir', 'dir')
        mkdir(savedir)
    end
end

for I = 1:length(clusters)
    if strcmp(method, 'lowerbound')
        clear CL
        CL.x = clusters{I}(:,1);
        CL.y = clusters{I}(:,2);
        CL.z = clusters{I}(:,3);
        tp_bounds(I) = clustertp_lowerbound(CL, cluster_threshold, 3);
        tdp_bounds(I) = tp_bounds(I)/length( CL.x );
    elseif strcmp(method, 'heuristic') || strcmp(method, 'greedy')
        cluster_log_dir = [savedir, '/cluster_', num2str(I), '/'];
        mkdir(cluster_log_dir);
        cluster2csv(clusters{I}, ['cluster_', num2str(I)], cluster_log_dir);
        fgreedy([cluster_log_dir, 'cluster_', num2str(I), '.csv'], cluster_threshold, 1, 1)
        fprintf('Jobs running the heuristic lower bound have been dispatched,\nyou can monitor the progress using the monitor_cTDP function\n') 
    else
        error('The method must be either lower_bounds or heuristic\n')
    end
end

end