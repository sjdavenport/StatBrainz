%% test_pearsrnd
% Tests of the pearsrnd function.
%--------------------------------------------------------------------------
n = 20000;
sample_moments = @(r) [mean(r), std(r), mean(((r - mean(r))/std(r)).^3), ...
                       mean(((r - mean(r))/std(r)).^4)];

%% Output sizes
rng(1)
assert(isequal(size(pearsrnd(0, 1, 0, 3)), [1, 1]))
assert(isequal(size(pearsrnd(0, 1, 0, 3, 4)), [4, 4]))
assert(isequal(size(pearsrnd(0, 1, 1, 4, [2, 3])), [2, 3]))
assert(isequal(size(pearsrnd(0, 1, 1, 4, 2, 3, 4)), [2, 3, 4]))

%% Skewness 0 and kurtosis 3 is the normal distribution (type 0)
rng(2)
[r, type] = pearsrnd(0, 1, 0, 3, n, 1);
assert(type == 0)
m = sample_moments(r);
assert(abs(m(1)) < 0.05 && abs(m(2) - 1) < 0.05 && abs(m(3)) < 0.1 && abs(m(4) - 3) < 0.2)

%% mu and sigma give the mean and standard deviation
rng(3)
r = pearsrnd(2, 3, 0, 3, n, 1);
assert(abs(mean(r) - 2) < 0.1 && abs(std(r) - 3) < 0.1)

%% Type I (beta): skewness 1, kurtosis 4
rng(4)
[r, type] = pearsrnd(2, 3, 1, 4, n, 1);
assert(type == 1)
m = sample_moments(r);
assert(abs(m(1) - 2) < 0.1 && abs(m(2) - 3) < 0.1 && abs(m(3) - 1) < 0.1 && abs(m(4) - 4) < 0.3)

%% Type II (symmetric beta): skewness 0, kurtosis 2.5
rng(5)
[r, type] = pearsrnd(0, 1, 0, 2.5, n, 1);
assert(type == 2)
m = sample_moments(r);
assert(abs(m(3)) < 0.1 && abs(m(4) - 2.5) < 0.1)

%% Type III (gamma): kurtosis = 3 + 1.5*skew^2
rng(6)
[r, type] = pearsrnd(0, 1, 2, 9, n, 1);
assert(type == 3)
m = sample_moments(r);
assert(abs(m(2) - 1) < 0.05 && abs(m(3) - 2) < 0.2)
assert(all(r > -1 - 1e-12))  % a gamma with skew 2 is bounded below by -2/skew

%% Type IV: skewness 1, kurtosis 6
rng(7)
[r, type] = pearsrnd(0, 1, 1, 6, n, 1);
assert(type == 4)
m = sample_moments(r);
assert(abs(m(1)) < 0.05 && abs(m(2) - 1) < 0.05)
assert(abs(m(3) - 1) < 0.3)

%% Type VII (Student t): skewness 0, kurtosis 6
rng(8)
[r, type] = pearsrnd(0, 1, 0, 6, n, 1);
assert(type == 7)
assert(isreal(r))
assert(abs(mean(r)) < 0.05 && abs(std(r) - 1) < 0.1)

%% Error for sigma <= 0
errored = 0;
try
    pearsrnd(0, 0, 0, 3);
catch
    errored = 1;
end
assert(errored == 1)

%% Error for kurt <= skew^2 + 1
errored = 0;
try
    pearsrnd(0, 1, 1, 2);
catch
    errored = 1;
end
assert(errored == 1)
