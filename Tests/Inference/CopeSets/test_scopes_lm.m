% Tests for scopes_lm (needs fastlmperm and lmthresh2scb)

rng(32)
nsubj = 40; nvox = 30;
X = randn(nsubj, 1);
design_matrix = [X, ones(nsubj, 1)];
contrast_matrix = [1, 0];
beta = linspace(-1, 1, nvox);
data = (X*beta + randn(nsubj, nvox))';  % nvox by nsubj

%% Output sizes and lower band below upper band
[lower_band, upper_band] = scopes_lm(data, design_matrix, contrast_matrix, 200, 0.05, 0);
assert(numel(lower_band) == nvox && numel(upper_band) == nvox)
assert(all(lower_band(:) <= upper_band(:)))

%% The bands contain the least squares estimate
betahat = design_matrix\data';
Cbetahat = contrast_matrix*betahat;
assert(all(lower_band(:) <= Cbetahat(:)) && all(Cbetahat(:) <= upper_band(:)))

%% Defaults for nboot, alpha and show_loader
[lower_band, upper_band] = scopes_lm(data, design_matrix, contrast_matrix);
assert(numel(lower_band) == nvox)
