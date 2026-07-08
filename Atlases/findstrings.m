function [ indices, matches ] = findstrings( strings, target )
% FINDSTRINGS( strings, target ) finds the entries of a cell array of
% strings that contain the target string as a substring and returns their
% indices together with the matching strings.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%   strings - a cell array of strings to search through
%   target  - a string to search for as a substring within each entry of
%             strings
%--------------------------------------------------------------------------
% OUTPUT
%   indices - a row vector of the indices of the entries of strings that
%             contain target
%   matches - a cell array of the entries of strings that contain target
%--------------------------------------------------------------------------
% EXAMPLES
%   names = {'Left Amygdala', 'Right Amygdala', 'Left Hippocampus'};
%   [indices, matches] = findstrings(lower(names), 'amygdala')
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

% Locate the entries that contain the target as a substring
contains_target = ~cellfun(@isempty, strfind(strings, target));

% Return the indices and the matching strings
indices = find(contains_target);
matches = strings(contains_target);

end
