%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the get_pivotal_stats function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For the linear template t_k(lambda) = lambda*k/m the pivotal statistic
% (Blanchard et al. 2020, section 4.5) of permutation b is
%   psi_b = min_{1 <= k <= K} p0_(k)(b)*m/k
% where p0_(k)(b) is the kth smallest p-value of permutation b.
rng(0)
inv_template = @(y, k, m) inverse_linear_template(y, k, m);

%% Output size
p0 = rand(20, 8);
pivotal_stats = get_pivotal_stats( p0, inv_template, -1 );
assert( isequal( size(pivotal_stats), [20,1] ) )

%% Does not depend on the order of the hypotheses
perm = randperm(8);
assert( isequal( get_pivotal_stats( p0(:,perm), inv_template, -1 ), pivotal_stats ) )

%% K restricts the minimum to the first K sorted p-values
p0 = rand(15, 6);
ps_all = get_pivotal_stats( p0, inv_template, -1 );
ps_1   = get_pivotal_stats( p0, inv_template, 1 );
ps_6   = get_pivotal_stats( p0, inv_template, 6 );
assert( isequal( ps_all, ps_6 ) )
assert( all( ps_all <= ps_1 ) )

%% K = 1 gives the minimum p-value (Bonferroni pivotal statistic) times m
% psi_b = min(p0(b,:))*m/1
p0 = rand(10, 5);
ps_1 = get_pivotal_stats( p0, inv_template, 1 );
assert( max(abs( ps_1 - min(p0, [], 2)*5 )) < 1e-12, ...
    'get_pivotal_stats does not match min_k p0_(k)*m/k for K = 1' )

%% Known values for the linear template
p0 = [ 0.10, 0.02, 0.60 ; ...
       0.30, 0.90, 0.24 ];
% Row 1: sorted 0.02, 0.10, 0.60 -> 0.06, 0.15, 0.60 -> min 0.06
% Row 2: sorted 0.24, 0.30, 0.90 -> 0.72, 0.45, 0.90 -> min 0.45
ps = get_pivotal_stats( p0, inv_template, -1 );
assert( max(abs( ps - [0.06; 0.45] )) < 1e-12, ...
    'get_pivotal_stats does not match min_k p0_(k)*m/k' )
