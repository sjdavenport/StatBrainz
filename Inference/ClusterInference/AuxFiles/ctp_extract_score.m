function [minscore_min, time_taken] = ctp_extract_score(filename)
% CTP_EXTRACT_SCORE Extracts minscore and time from a CTP log file.
%
% [minscore_min, time_taken] = CTP_EXTRACT_SCORE(filename)
% reads the specified log file and extracts minscore values and
% corresponding times. It then returns the minimum minscore and the
% maximum time among the extracted values.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory:
%   - filename: The path to the CTP log file.
%
% OUTPUT
%   - minscore_min: The minimum minscore value found in the log file.
%   - time_taken: The maximum time value found in the log file.
%--------------------------------------------------------------------------
% EXAMPLE
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------
    % Read the log file
    fid = fopen(filename, 'r');
    if fid == -1
        error('Error opening file %s', filename);
    end

    % Read lines from the file
    lines = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);

    % Extract minscore values and times
    minscorePattern = 'minscore=(\d+)';
    minscorePattern2 = 'minscore:(\d+)';
    timePattern = 'time=([\d.]+)';
    timePattern2 = 'totaltime_sec:([\d.]+)';
    minscores = [];
    times = [];

    for i = 1:numel(lines{1})
        minscoreMatch = regexp(lines{1}{i}, minscorePattern, 'tokens');
        if isempty(minscoreMatch)
            minscoreMatch = regexp(lines{1}{i}, minscorePattern2, 'tokens');
        end
        timeMatch = regexp(lines{1}{i}, timePattern, 'tokens');
        if isempty(timeMatch)
            timeMatch = regexp(lines{1}{i}, timePattern2, 'tokens');
        end

        if ~isempty(minscoreMatch)
            minscores = [minscores, str2double(minscoreMatch{1})];
        end
        if ~isempty(timeMatch)
            times = [times, str2double(timeMatch{1})];
        end
    end

    % Find the last occurrence of the minimum minscore
    minscore_min = min(minscores);

    % Display the corresponding information (optional)
    time_taken = max(times);
end
