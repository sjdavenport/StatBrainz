%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the cluster_im function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)

%% 2D: clusters larger than the threshold survive
dim = [5,6];
index_locations = { [1;2], [10;11;12], 30 };
[im, clusters, clusters_vec] = cluster_im( dim, index_locations, 1.5 );
expected = zeros(dim); expected([1,2,10,11,12]) = 1;
assert( isequal( im, expected ) )
assert( numel(clusters_vec) == 2 )
assert( isequal( clusters_vec{1}, [1;2] ) && isequal( clusters_vec{2}, [10;11;12] ) )

%% Subscripts of the surviving clusters
[r, c] = ind2sub( dim, [10;11;12] );
assert( numel(clusters) == 2 )
assert( isequal( clusters{2}(:,1:2), [r, c] ) )

%% The threshold is strict (size must be > threshold)
im = cluster_im( dim, index_locations, 2 );
assert( sum(im(:)) == 3 )
im = cluster_im( dim, index_locations, 3 );
assert( sum(im(:)) == 0 )

%% 3D
dim = [4,4,4];
idx = sub2ind( dim, [1;2;3], [1;1;1], [2;2;2] );
[im, clusters] = cluster_im( dim, {idx, 64}, 0.5 );
assert( isequal( size(im), dim ) )
assert( sum(im(:)) == 4 )
assert( isequal( clusters{1}, [ [1;2;3], [1;1;1], [2;2;2] ] ) )

%% No clusters
[im, clusters, clusters_vec] = cluster_im( [3,3], {}, 0.5 );
assert( isequal( im, zeros(3,3) ) )
assert( isempty( clusters ) && isempty( clusters_vec ) )
