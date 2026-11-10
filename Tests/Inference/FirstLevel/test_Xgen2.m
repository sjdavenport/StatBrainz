% Tests for Xgen2

%% rho = 0 gives white noise of size n by m
rng(10)
X = Xgen2(5, 7, 0, 'ar1');
assert(isequal(size(X), [5, 7]))
rng(10)
assert(isequal(X, randn(5, 7)))

%% ar1: unit variance and lag 1 correlation rho
rng(11)
rho = 0.7;
X = Xgen2(4000, 30, rho, 'ar1');
assert(isequal(size(X), [4000, 30]))
assert(abs(mean(var(X(:, 10:end), 0, 1)) - 1) < 0.05)
lag1 = mean(sum(X(:, 2:end).*X(:, 1:end-1), 1)/4000);
assert(abs(lag1 - rho) < 0.05)

%% ar1: the first columns also have unit variance (X is standardised)
rng(11)
X = Xgen2(4000, 30, 0.7, 'ar1');
assert(abs(var(X(:, 1)) - 1) < 0.1)

%% equi: unit variance and equal correlation rho between columns
rng(12)
X = Xgen2(4000, 20, 0.5, 'equi');
assert(isequal(size(X), [4000, 20]))
assert(abs(mean(var(X, 0, 1)) - 1) < 0.05)
C = corrcoef(X);
offdiag = C(~eye(20));
assert(abs(mean(offdiag) - 0.5) < 0.05)

%% Gaussian: unit variance
rng(13)
X = Xgen2(2000, 50, 2, 'Gaussian');
assert(isequal(size(X), [2000, 50]))
assert(abs(mean(var(X, 0, 2)) - 1) < 0.1)

%% ar1mix: two blocks of columns
rng(14)
X = Xgen2(3000, 100, [0.9, 0], 'ar1mix');
assert(isequal(size(X), [3000, 100]))
lag1_first = mean(sum(X(:, 31:50).*X(:, 30:49), 1)/3000);
lag1_second = mean(sum(X(:, 82:100).*X(:, 81:99), 1)/3000);
assert(abs(lag1_first - 0.9) < 0.05)
assert(abs(lag1_second) < 0.05)

%% 012: values from 0/1/2 data, demeaned and standardised
rng(15)
X = Xgen2(2000, 10, 0.5, '012');
assert(isequal(size(X), [2000, 10]))
assert(numel(unique(X)) == 3)
assert(abs(mean(X(:))) < 0.05)
assert(abs(mean(var(X, 0, 1)) - 1) < 0.1)

%% 012equi: values 0, 1 and 2
rng(16)
X = Xgen2(500, 10, 0.5, '012equi');
assert(isequal(size(X), [500, 10]))
assert(all(ismember(X(:), [0, 1, 2])))

%% An unknown method gives an error
try
    X = Xgen2(5, 5, 0.5, 'unknown_method');
    errored = 0;
catch
    errored = 1;
end
assert(errored == 1)
