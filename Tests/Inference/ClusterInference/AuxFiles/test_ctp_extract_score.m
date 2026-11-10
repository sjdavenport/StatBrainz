%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the ctp_extract_score function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)
logdir = [tempname, '/'];
mkdir(logdir);

%% Finished log file
fid = fopen( [logdir, 'done.log'], 'w' );
fprintf( fid, 'start\n' );
fprintf( fid, '[1] 10/20. minscore=40  #3 [+2] time=0.50\n' );
fprintf( fid, '[2] 11/20. minscore=35  #1 [+5] time=1.25\n' );
fprintf( fid, 'final minscore:37\n' );
fprintf( fid, 'totaltime_sec:3.75\n' );
fclose( fid );
[minscore_min, time_taken, has_finished] = ctp_extract_score( [logdir, 'done.log'] );
assert( minscore_min == 35 )
assert( abs( time_taken - 3.75 ) < 1e-12 )
assert( has_finished == 1 )

%% Log file of a job that has not finished
fid = fopen( [logdir, 'running.log'], 'w' );
fprintf( fid, 'minscore=12 time=0.1\n' );
fprintf( fid, 'minscore=9 time=0.7\n' );
fclose( fid );
[minscore_min, time_taken, has_finished] = ctp_extract_score( [logdir, 'running.log'] );
assert( minscore_min == 9 )
assert( abs( time_taken - 0.7 ) < 1e-12 )
assert( has_finished == 0 )

%% Error for a file that does not exist
try
    ctp_extract_score( [logdir, 'nofile.log'] );
    errored = 0;
catch
    errored = 1;
end
assert( errored == 1 )

rmdir( logdir, 's' );
