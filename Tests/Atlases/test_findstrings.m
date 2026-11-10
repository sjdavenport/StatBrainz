%% test_findstrings
% Tests of the findstrings function.
%--------------------------------------------------------------------------
names = {'left amygdala', 'right amygdala', 'left hippocampus'};

%% Known matches
[indices, matches] = findstrings(names, 'amygdala');
assert(isequal(indices, [1, 2]))
assert(isequal(matches, {'left amygdala', 'right amygdala'}))

%% Substring in the middle of the entry
[indices, matches] = findstrings(names, 'hippo');
assert(isequal(indices, 3))
assert(isequal(matches, {'left hippocampus'}))

%% No match gives empty output
[indices, matches] = findstrings(names, 'thalamus');
assert(isempty(indices) && isempty(matches))

%% The search is case sensitive
[indices, ~] = findstrings(names, 'Amygdala');
assert(isempty(indices))
[indices, ~] = findstrings(lower({'Left Amygdala', 'Brain-Stem'}), 'amygdala');
assert(isequal(indices, 1))
