% Tests for prewhiten

rng(17)
% AR(1) data along each row: data(:,t) = 0.5*data(:,t-1) + noise
data = filter(1, [1, -0.5], randn(3, 50), [], 2);

%% The output has the same size as the input
data_pw = prewhiten(data);
assert(isequal(size(data_pw), size(data)))

%% Each row is divided by its standard deviation
expected = data./std(data, 0, 2);
assert(max(abs(data_pw(:) - expected(:))) < 1e-10)

%% Each row of the output has unit variance
assert(all(abs(var(data_pw, 0, 2) - 1) < 1e-10))
