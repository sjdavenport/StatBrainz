%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the ctp_scores function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ctp_scores reads <logdir>/cluster_<I>/fgreedy.log for I = 1, 2, ...
rng(0)
logdir = tempname;
mkdir(logdir);
scores = [7, 3, 12, 5, 9, 1, 4, 8, 2, 6, 11];   % 11 clusters
for I = 1:length(scores)
    cdir = fullfile( logdir, ['cluster_', num2str(I)] );
    mkdir(cdir);
    fid = fopen( fullfile(cdir, 'fgreedy.log'), 'w' );
    fprintf( fid, 'minscore=%d time=0.5\n', scores(I) + 10 );
    fprintf( fid, 'minscore=%d time=1.0\n', scores(I) );
    if I ~= 4
        fprintf( fid, 'totaltime_sec:2.0\n' );
    end
    fclose( fid );
end
% A file that is not a cluster folder must be ignored
fid = fopen( fullfile(logdir, 'notes.txt'), 'w' ); fclose( fid );

%% Bounds are returned in numeric cluster order (cluster_10 after cluster_9)
tp_bounds = ctp_scores( logdir );
assert( isequal( tp_bounds, scores ) )

%% A trailing file separator gives the same result
assert( isequal( ctp_scores( [logdir, filesep] ), scores ) )

%% Empty directory
emptydir = tempname;
mkdir(emptydir);
assert( isempty( ctp_scores( emptydir ) ) )

rmdir( logdir, 's' );
rmdir( emptydir, 's' );
