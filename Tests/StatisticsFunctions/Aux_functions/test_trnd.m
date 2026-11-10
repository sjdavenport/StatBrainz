%% test_trnd
% Tests of the trnd function.
%--------------------------------------------------------------------------

%% Output sizes
rng(1)
assert(isequal(size(trnd(5)), [1, 1]))
assert(isequal(size(trnd(5, 4)), [4, 4]))
assert(isequal(size(trnd(5, [2, 3])), [2, 3]))
assert(isequal(size(trnd(5, 2, 3, 4)), [2, 3, 4]))
assert(isreal(trnd(5, 10, 1)) && all(isfinite(trnd(5, 10, 1))))

%% Same seed gives the same draws
rng(7); a = trnd(4, 5, 5);
rng(7); b = trnd(4, 5, 5);
assert(isequal(a, b))

%% Mean 0 and variance nu/(nu - 2) for nu = 6
rng(2)
r = trnd(6, 20000, 1);
assert(abs(mean(r)) < 0.05)
assert(abs(var(r) - 6/4) < 0.1)

%% Tail probability for nu = 10: P(|T| < 2.2281) = 0.95
rng(3)
r = trnd(10, 20000, 1);
assert(abs(mean(abs(r) < 2.2281) - 0.95) < 0.01)

%% nu = 1 is the Cauchy distribution: P(|T| < 1) = 0.5
% (the Gamma shape is 1/2 < 1, so this checks the boosted sampler)
rng(4)
r = trnd(1, 20000, 1);
assert(abs(mean(abs(r) < 1) - 0.5) < 0.015)

%% Non-integer nu = 2.5: the median is 0 and P(T < 1) matches the t CDF
% For nu = 2.5, P(T < 1) = 0.79847 (from betainc)
rng(5)
r = trnd(2.5, 20000, 1);
p = 1 - 0.5*betainc(2.5/(2.5 + 1), 2.5/2, 0.5);
assert(abs(mean(r < 1) - p) < 0.01)
assert(abs(mean(r < 0) - 0.5) < 0.01)

%% Error for a bad nu
for nu = {0, -1, [1, 2], 'a'}
    errored = 0;
    try
        trnd(nu{1}, 2);
    catch
        errored = 1;
    end
    assert(errored == 1)
end
