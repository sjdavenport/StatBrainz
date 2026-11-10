% Tests for prewhiten

rng(17)
data = Xgen2(3, 50, 0.5, 'ar1');

%% The output has the same size as the input
data_pw = prewhiten(data);
assert(isequal(size(data_pw), size(data)))

%% Each row is divided by its standard deviation
expected = data./std(data, 0, 2);
assert(max(abs(data_pw(:) - expected(:))) < 1e-10)

%% Each row of the output has unit variance
assert(all(abs(var(data_pw, 0, 2) - 1) < 1e-10))
