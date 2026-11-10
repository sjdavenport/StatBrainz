%% test_loader
% Tests of the loader function.
%--------------------------------------------------------------------------

%% The first call prints a line and the default message
out = evalc('loader(1, 4)');
assert(contains(out, '-------'))
assert(contains(out, 'Percent done:'))
assert(contains(out, '25.0'))

%% A given message replaces the default
out = evalc('loader(1, 10, ''Total progress:'')');
assert(contains(out, 'Total progress:'))
assert(~contains(out, 'Percent done:'))
assert(contains(out, '10.0'))

%% Later calls remove the last value with backspaces and print the new one
out = evalc('loader(3, 4)');
assert(~contains(out, 'Percent done:'))
assert(contains(out, '75.0'))
nback = sum(out == sprintf('\b'));
assert(nback == length(sprintf('%3.1f\n', 75)))

%% A full loop ends at 100 percent
out = evalc('for I = 1:20, loader(I, 20), end');
assert(contains(out, '100.0'))
