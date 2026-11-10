%% test_apower
% Tests of the apower function.
%--------------------------------------------------------------------------

%% Default power is 1/2 and keeps the sign
assert(isequal(apower([-4, 0, 9]), [-2, 0, 3]))

%% Given power
assert(isequal(apower([-2, 2, 3], 3), [-8, 8, 27]))
assert(abs(apower(-27, 1/3) + 3) < 1e-12)

%% Agrees with sign(x).*abs(x).^power and keeps the size
rng(1)
x = randn(4, 5, 3);
y = apower(x, 0.7);
assert(isequal(size(y), size(x)))
assert(max(abs(y(:) - sign(x(:)).*abs(x(:)).^0.7)) < 1e-12)

%% The output is real for negative values
assert(isreal(apower(-randn(1,10).^2, 0.3)))

%% Power 1 is the identity
assert(isequal(apower(x, 1), x))
