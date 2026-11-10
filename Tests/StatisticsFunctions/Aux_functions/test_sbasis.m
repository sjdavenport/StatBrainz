%% test_sbasis
% Tests of the sbasis function.
%--------------------------------------------------------------------------

%% Known value
assert(isequal(sbasis(2, 4), [0; 1; 0; 0]))

%% Size and sum
out = sbasis(3, 5);
assert(isequal(size(out), [5, 1]) && sum(out) == 1 && out(3) == 1)

%% The basis vectors give the identity matrix
I = zeros(3);
for d = 1:3
    I(:, d) = sbasis(d, 3);
end
assert(isequal(I, eye(3)))
