%% test_tstat2pval
% Tests for tstat2pval: p-values from t-statistics.
%--------------------------------------------------------------------------
tol = 1e-6;

%% t = 0 gives p = 1 (two-sided) and p = 0.5 (one-sided)
assert( abs( tstat2pval( 0, 10 ) - 1 ) < tol )
assert( abs( tstat2pval( 0, 10, 0 ) - 0.5 ) < tol )

%% Known values
assert( abs( tstat2pval( 2.228139, 10 ) - 0.05 ) < tol )
assert( abs( tstat2pval( 1.812461, 10, 0 ) - 0.05 ) < tol )

%% Default is two-sided
t = [-3 -1 0.5 2];
assert( isequal( tstat2pval( t, 6 ), tstat2pval( t, 6, 1 ) ) )

%% Two-sided p-values are symmetric in t, one-sided are not
assert( max( abs( tstat2pval( t, 6 ) - tstat2pval( -t, 6 ) ) ) < tol )
assert( max( abs( tstat2pval( t, 6, 0 ) + tstat2pval( -t, 6, 0 ) - 1 ) ) < tol )

%% Two-sided p is twice the one-sided p for positive t
assert( abs( tstat2pval( 2, 6 ) - 2*tstat2pval( 2, 6, 0 ) ) < tol )

%% Output has the size of tstat
assert( isequal( size( tstat2pval( ones(3,2,2), 5 ) ), [3 2 2] ) )
