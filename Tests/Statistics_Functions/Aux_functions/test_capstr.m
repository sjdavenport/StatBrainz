%% test_capstr
% Tests of the capstr function.
%--------------------------------------------------------------------------

%% Capitalises the first letter of each word
assert(strcmp(capstr('this is a tEST'), 'This Is A Test'))

%% A single word
assert(strcmp(capstr('FRONTAL'), 'Frontal'))

%% Cell array input gives a 1 by n cell array
out = capstr({'left hemisphere', 'RIGHT pole'});
assert(iscell(out) && isequal(size(out), [1, 2]))
assert(strcmp(out{1}, 'Left Hemisphere') && strcmp(out{2}, 'Right Pole'))
