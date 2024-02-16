function fgreedy( cluster_csv_loc, cluster_threshold, runinbackground, usewsl )
% fgreedy(cluster_csv_loc, runinbackground, usewsl) run the fgreedy
% algorithm on a CSV file containing the cluster locations.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory:
%   cluster_csv_loc  - Path to the cluster CSV file.
%   cluster_threshold - an integer giving the cluster threshold
% Optional:
%   runinbackground  - Flag to run the algorithm in the background (default: 1).
%   usewsl           - Flag to indicate whether to use Windows Subsystem 
%                      for Linux (WSL) (default: 0).
%--------------------------------------------------------------------------
% EXAMPLES
% fgreedy('./ClusterTDPccode/k90.csv', 8, 1, 1)
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'runinbackground', 'var' )
   % Default value
   runinbackground = 1;
end

if ~exist( 'usewsl', 'var' )
   % Default value
   usewsl = 0;
end
%%  Main Function Loop
%--------------------------------------------------------------------------
fgreedy_loc = which('fgreedy.c');
fgreedy_loc = fgreedy_loc(1:end-9);
% cluster_csv_loc = './ClusterTDPccode/k90.csv';
if usewsl == 0
    if runinbackground == 1
        system([fgreedy_loc, 'fgreedy ', cluster_csv_loc,' -x ', fgreedy_loc, 'batch7.cnf -k',num2str(cluster_threshold),', &']);
    else
        system([fgreedy_loc, 'fgreedy ', cluster_csv_loc,' -x ', fgreedy_loc, 'batch7.cnf -k',num2str(cluster_threshold)]);
    end
else
    cd(fileparts(cluster_csv_loc)); %fileparts extracts the folder name!
    fgreedy_loc = strrep(fgreedy_loc, '\', '\\');
    fgreedy_loc = strrep(fgreedy_loc, '/', '\\');
    cluster_csv_loc = strrep(cluster_csv_loc, '\', '\\');
    cluster_csv_loc = strrep(cluster_csv_loc, '/', '\\');
    [~, fgreedy_loc] = system(['wsl wslpath -u "' fgreedy_loc '"']);
    [~, cluster_csv_loc] = system(['wsl wslpath -u "' cluster_csv_loc '"']);
    fgreedy_loc = strtrim(fgreedy_loc);
    cluster_csv_loc = strtrim(cluster_csv_loc);
    if runinbackground == 1
        system(['wsl ', fgreedy_loc, 'fgreedy ', cluster_csv_loc,' -x ', fgreedy_loc, 'batch7.cnf -k',num2str(cluster_threshold),'&& exit &']);
    else
        system(['wsl ', fgreedy_loc, 'fgreedy ', cluster_csv_loc,' -x ', fgreedy_loc, 'batch7.cnf -k',num2str(cluster_threshold)]);
    end
end

end

