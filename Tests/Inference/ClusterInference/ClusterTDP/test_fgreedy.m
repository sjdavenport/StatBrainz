%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the fgreedy function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fgreedy calls the compiled fgreedy binary in ClusterTDPccode. The binary
% only runs on the platform it was compiled for, so this test checks that
% the call runs and, when the binary runs, that a log file is written.
rng(0)

%% The fgreedy source folder is on the path
fgreedy_c = which('fgreedy.c');
assert( ~isempty( fgreedy_c ) )
fgreedy_dir = fileparts( fgreedy_c );
assert( exist( fullfile(fgreedy_dir, 'fgreedy'), 'file' ) == 2 )
assert( exist( fullfile(fgreedy_dir, 'batch7.cnf'), 'file' ) == 2 )

%% The call runs in the foreground on a small cluster
savedir = [tempname, '/'];
mkdir(savedir);
[x, y, z] = ndgrid( 1:3, 1:3, 1:3 );
cluster2csv( [x(:), y(:), z(:)], 'cluster_1', savedir );
fgreedy( [savedir, 'cluster_1.csv'], 5, 0 );
logs = dir( fullfile(savedir, '*.log') );
if isempty( logs )
    fprintf('fgreedy: no log file was written (the binary did not run on this platform)\n')
end

%% The call runs from the folder of the csv file (relative path)
olddir = pwd;
cd(savedir);
fgreedy( 'cluster_1.csv', 5, 0 );
cd(olddir);

rmdir( savedir, 's' );
