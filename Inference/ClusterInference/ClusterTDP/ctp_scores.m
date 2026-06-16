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

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
cluster_names = filesindir(logdir);
tp_bounds = zeros(1, length(cluster_names));
for I = 1:length(cluster_names)
    [tp_bounds(I), timetaken, hasfinished] = ctp_extract_score([logdir,cluster_names{I},'/fgreedy.log']);
    if ~hasfinished
        fprintf(['The computation for ',num2str(cluster_names{I}),' is still in progress\n'])
    end
end

end

