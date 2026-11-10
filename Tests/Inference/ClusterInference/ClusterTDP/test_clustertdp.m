%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the clustertdp function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)
mkCL = @(xyz) struct( 'x', xyz(:,1), 'y', xyz(:,2), 'z', xyz(:,3) );
[x, y, z] = ndgrid( 1:2, 1:2, 1:2 );
cube = [x(:), y(:), z(:)];
[x, y, z] = ndgrid( 1:5, 1:4, 1:3 );
block = [x(:), y(:), z(:)] + 20;
clusters = { cube, block };

%% Default method (lowerbound) matches clustertp_lowerbound
[tdp_bounds, tp_bounds] = clustertdp( clusters, 1 );
assert( isequal( size(tdp_bounds), [1,2] ) && isequal( size(tp_bounds), [1,2] ) )
assert( tp_bounds(1) == 5 )    % known value, see test_clustertp_lowerbound
assert( tp_bounds(2) == clustertp_lowerbound( mkCL(block), 1, 3 ) )
assert( max(abs( tdp_bounds - tp_bounds./[8, 60] )) < 1e-12 )

%% Explicit 'lowerbound' gives the same result
[tdp2, tp2] = clustertdp( clusters, 1, 'lowerbound' );
assert( isequal( tdp2, tdp_bounds ) && isequal( tp2, tp_bounds ) )

%% TDP bounds are in [0,1]
[tdp_bounds, tp_bounds] = clustertdp( clusters, 10 );
assert( all( tdp_bounds >= 0 & tdp_bounds <= 1 ) )
assert( tp_bounds(1) == 0 )    % 8 voxels is not more than the threshold

%% No clusters
[tdp_bounds, tp_bounds] = clustertdp( {}, 5 );
assert( isempty( tdp_bounds ) && isempty( tp_bounds ) )

%% Error for an unknown method
try
    clustertdp( clusters, 1, 'nomethod' );
    errored = 0;
catch
    errored = 1;
end
assert( errored == 1 )
