%% test_pad_vals
% Tests of the pad_vals function.
%--------------------------------------------------------------------------

%% 1D row vector with default value
[out, locs] = pad_vals(ones(1, 3), 2);
assert(isequal(out, [0 0 1 1 1 0 0]))
assert(isequal(locs{1}, 3:5))

%% 2D default padding
out = pad_vals(ones(2));
assert(isequal(size(out), [4, 4]) && sum(out(:)) == 4)
assert(isequal(out(2:3, 2:3), ones(2)))

%% 2D asymmetric padding and a non-zero value
[out, locs] = pad_vals(ones(2), [1 2; 2 1], 5);
assert(isequal(size(out), [5, 5]))
assert(isequal(locs{1}, 2:3) && isequal(locs{2}, 3:4))
assert(isequal(out(locs{:}), ones(2)) && sum(out(:) == 5) == 21)

%% Logical value gives a logical output
out = pad_vals(true(2), 1, false);
assert(islogical(out) && sum(out(:)) == 4)

%% Wrong size of padn gives an error
errored = 0;
try
    pad_vals(ones(2), [1 2 3]);
catch
    errored = 1;
end
assert(errored == 1)
