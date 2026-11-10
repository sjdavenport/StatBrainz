function fgreedy( cluster_csv_loc, cluster_threshold, runinbackground )
% fgreedy(cluster_csv_loc, cluster_threshold, runinbackground) run the fgreedy
% algorithm on a CSV file containing the cluster locations.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory:
%   cluster_csv_loc  - Path to the cluster CSV file.
%   cluster_threshold - an integer giving the cluster threshold
% Optional:
%   runinbackground  - Flag to run the algorithm in the background (default: 1).
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% OUTPUT
% None (runs the fgreedy binary as a system call; output is written to a
% log file alongside the CSV, as the binary is run from the CSV's folder)
%--------------------------------------------------------------------------
% EXAMPLES
% fgreedy('./ClusterTDPccode/k90.csv', 8, 1)
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'runinbackground', 'var' )
   % Default value
   runinbackground = 1;
end
%%  Main Function Loop
%--------------------------------------------------------------------------
fgreedy_loc = which('fgreedy.c');
fgreedy_loc = fgreedy_loc(1:end-9);
[csv_dir, csv_name, csv_ext] = fileparts(cluster_csv_loc);
if isempty(csv_dir)
    csv_dir = '.';
end
cmd = ['cd "', csv_dir, '" && "', fgreedy_loc, 'fgreedy" "', csv_name, csv_ext, ...
       '" -x "', fgreedy_loc, 'batch7.cnf" -k', num2str(cluster_threshold)];
if runinbackground == 1
    system([cmd, ' &']);
else
    system(cmd);
end

end
