%% test_distbn2pval
% Tests for distbn2pval: empirical p-values, the proportion of distbn >= value.
%--------------------------------------------------------------------------

%% Known values
pv = distbn2pval( 1:10, [0 5 10 11] );
assert( isequal( pv, [1 0.6 0.1 0] ) )

%% Output is a row vector, also for column input
pv = distbn2pval( (1:4)', [2; 3] );
assert( isequal( size(pv), [1 2] ) && isequal( pv, [0.75 0.5] ) )

%% Ties count as >=
assert( distbn2pval( [1 1 1 2], 1 ) == 1 )
assert( distbn2pval( [1 1 1 2], 2 ) == 0.25 )

%% Agrees with the CDF of a large sample
rng(0); d = randn(1, 1e5);
assert( abs( distbn2pval( d, 1.6449 ) - 0.05 ) < 0.005 )
