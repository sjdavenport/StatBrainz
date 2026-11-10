%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the cluster_tp2tdp function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)

%% Known values with linear index clusters
tdp = cluster_tp2tdp( [5, 10, 3], {1:8, 1:15, 1:6} );
assert( max(abs( tdp - [5/8, 10/15, 3/6] )) < 1e-12 )

%% Column vector clusters and a zero bound
tdp = cluster_tp2tdp( [0, 4], { (1:4)', (11:20)' } );
assert( isequal( size(tdp), [1,2] ) )
assert( max(abs( tdp - [0, 0.4] )) < 1e-12 )

%% TDP is the TP bound divided by the cluster size
sizes = randi(50, 1, 6);
clusters = arrayfun( @(n) 1:n, sizes, 'UniformOutput', false );
tp = floor( rand(1,6).*sizes );
assert( max(abs( cluster_tp2tdp( tp, clusters ) - tp./sizes )) < 1e-12 )
