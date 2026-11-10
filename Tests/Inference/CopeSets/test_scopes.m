% Tests for scopes (needs fastperm and fastperm_mean)

rng(30)
dim = [6, 6]; nsubj = 20;
data = randn([dim, nsubj]) + 1;

%% Output sizes and the bands are the mean -/+ threshold*std/sqrt(nsubj)
[lower_band, upper_band, threshold] = scopes(data, nsubj, 200, 0.05, 0);
assert(isequal(size(lower_band), dim) && isequal(size(upper_band), dim))
assert(isscalar(threshold) && threshold > 0)
xbar = mean(data, 3); sd = std(data, 0, 3);
assert(max(abs(upper_band(:) - (xbar(:) + threshold*sd(:)/sqrt(nsubj)))) < 1e-10)
assert(max(abs(lower_band(:) - (xbar(:) - threshold*sd(:)/sqrt(nsubj)))) < 1e-10)
assert(all(lower_band(:) <= upper_band(:)))

%% A smaller alpha gives wider bands
rng(31); [~, ~, t05] = scopes(data, nsubj, 500, 0.05, 0);
rng(31); [~, ~, t20] = scopes(data, nsubj, 500, 0.2, 0);
assert(t05 > t20)

%% With a given sigmahat the bands use it
sigmahat = ones(dim);
[lower_band, upper_band, threshold] = scopes(data, nsubj, 200, 0.05, 0, sigmahat);
assert(max(abs(upper_band(:) - (xbar(:) + threshold/sqrt(nsubj)))) < 1e-10)

%% show_loader is optional
[lower_band, upper_band] = scopes(data, nsubj, 100, 0.05);
assert(isequal(size(lower_band), dim))
