%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the real_tfce_clusters function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)
dim = [12,12];
tstat = zeros(dim);
tstat(2:4, 2:4) = 3;      % a strong 3x3 cluster
tstat(9:10, 9) = 1.5;     % a weak 2 voxel cluster
mask = ones(dim);
strong = zeros(dim); strong(2:4, 2:4) = 1;
weak   = zeros(dim); weak(9:10, 9) = 1;
tf_strong = max(max( tfce( tstat.*strong ) ));
tf_weak   = max(max( tfce( tstat.*weak ) ));

%% Only the clusters with a maximum TFCE above the threshold survive
thr = (tf_strong + tf_weak)/2;
[cl_im, clusters, pvals] = real_tfce_clusters( tstat, mask, thr, 2, 0.5, 8, 0.1, 0, ...
                                               [tf_weak - 1, thr, tf_strong + 1] );
assert( isequal( cl_im, strong ) )
assert( numel(clusters) == 1 )
assert( isequal( sort(clusters{1}(:)), find(strong) ) )

%% Cluster p-values (in the order of the clusters found)
% The strong cluster is found first (smaller linear indices)
assert( isequal( size(pvals), [1,2] ) )
assert( max(abs( pvals - [1/3, 2/3] )) < 1e-12 )

%% Default optional arguments
[cl_im_def, clusters_def] = real_tfce_clusters( tstat, mask, thr );
assert( isequal( cl_im_def, cl_im ) && isequal( clusters_def, clusters ) )

%% A low threshold keeps both clusters, a high threshold keeps none
cl_im = real_tfce_clusters( tstat, mask, tf_weak/2 );
assert( isequal( cl_im, strong + weak ) )
[cl_im, clusters] = real_tfce_clusters( tstat, mask, tf_strong + 1 );
assert( isequal( cl_im, zeros(dim) ) && isempty( clusters ) )

%% The mask is applied first
mask2 = ones(dim); mask2(1:6, 1:6) = 0;
cl_im = real_tfce_clusters( tstat, mask2, tf_weak/2 );
assert( isequal( cl_im, weak ) )

%% 3D
tstat3 = zeros(6,6,6); tstat3(2:3, 2:3, 2:3) = 2;
tf3 = max(max(max( tfce( tstat3 ) )));
cl_im3 = real_tfce_clusters( tstat3, ones(6,6,6), tf3 - 1 );
assert( isequal( cl_im3, double(tstat3 > 0) ) )
