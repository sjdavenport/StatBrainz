%% test_pval2tstat
% Tests for pval2tstat: one-sided p-value to t-statistic, -tinv(p, df).
%--------------------------------------------------------------------------
tol = 1e-6;

%% Known values
assert( abs( pval2tstat( 0.05, 10 ) - 1.812461 ) < tol )
assert( abs( pval2tstat( 0.025, 10 ) - 2.228139 ) < tol )
assert( abs( pval2tstat( 0.5, 7 ) ) < tol )

%% Small p-values give large t-statistics and p > 0.5 gives negative t
assert( pval2tstat( 0.001, 5 ) > pval2tstat( 0.01, 5 ) )
assert( pval2tstat( 0.9, 5 ) < 0 )

%% Output has the size of pval
p = [0.01 0.2; 0.5 0.7];
assert( isequal( size( pval2tstat( p, 4 ) ), [2 2] ) )

%% Round trip with the one-sided tstat2pval
assert( max( abs( tstat2pval( pval2tstat( p, 4 ), 4, 0 ) - p ), [], 'all' ) < tol )
