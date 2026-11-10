%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the ctp_extract_score function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Read the score from a finished fgreedy log file
% Write a small log file of the type that fgreedy writes
logfile = [tempname, '.log'];
fid = fopen(logfile, 'w');
fprintf(fid, '[1] 10/20. minscore=40  #3 [+2] time=0.50\n');
fprintf(fid, '[2] 11/20. minscore=35  #1 [+5] time=1.25\n');
fprintf(fid, 'totaltime_sec:3.75\n');
fclose(fid);
[minscore_min, time_taken, has_finished] = ctp_extract_score(logfile)

%% A log file of a job that is still running
fid = fopen(logfile, 'w');
fprintf(fid, '[1] 10/20. minscore=40  #3 [+2] time=0.50\n');
fclose(fid);
[minscore_min, time_taken, has_finished] = ctp_extract_score(logfile)

%% Read the log files of several clusters (as ctp_scores does)
logs = {'minscore=12 time=0.1', 'minscore=7 time=0.4'};
for I = 1:length(logs)
    fid = fopen(logfile, 'w'); fprintf(fid, '%s\ntotaltime_sec:1\n', logs{I}); fclose(fid);
    fprintf('cluster %d: TP lower bound %d\n', I, ctp_extract_score(logfile));
end
delete(logfile);
