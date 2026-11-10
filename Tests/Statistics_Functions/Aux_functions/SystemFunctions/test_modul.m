%% test_modul
% Tests of the modul function.
%--------------------------------------------------------------------------

%% Displays I when I is divisible by modval
out = evalc('modul(10, 5)');
assert(strcmp(strtrim(out), '10'))

%% Displays nothing otherwise
out = evalc('modul(11, 5)');
assert(isempty(strtrim(out)))

%% In a loop only the multiples are displayed
out = evalc('for I = 1:20, modul(I, 5), end');
assert(isequal(sscanf(out, '%d')', [5, 10, 15, 20]))

%% modval = 1 displays every value
out = evalc('for I = 1:3, modul(I, 1), end');
assert(isequal(sscanf(out, '%d')', [1, 2, 3]))
