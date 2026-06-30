%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the get_pivotal_stats function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rng(0)
% B = 100 permutations over p = 50 hypotheses
p0 = rand(100, 50);
inverse_template = @(y, k, m) inverse_linear_template(y, k, m);
K = -1;
pivotal_stats = get_pivotal_stats(p0, inverse_template, K);
size(pivotal_stats)
min(pivotal_stats)
