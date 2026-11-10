%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the perm_cluster function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The sign flips are drawn with binornd after all the other computations,
% so they can be drawn again with the same seed to check the output.
dim = [10,10]; nsubj = 12; nperm = 30;
CDT = 1.5; conn = 8; alpha = 0.1;
rng(1)
data = randn([dim, nsubj]);
data(3:6, 3:6, :) = data(3:6, 3:6, :) + 1.5;
mask = ones(dim);
maxsize = @(tstat) max( [0, cellfun(@numel, ...
                   getfield( conncomp_bw( tstat > CDT, conn ), 'PixelIdxList' ))] );

%% Output sizes
rng(2)
[threshold, vec_max, store] = perm_cluster( data, mask, CDT, conn, alpha, nperm, 0, 1 );
tstat_orig = mvtstat(data);
assert( isscalar(threshold) )
assert( isequal( size(vec_max), [1,nperm] ) )
assert( all( vec_max >= 0 ) )

%% The threshold is the 100(1-alpha) percentile of the maximum sizes
assert( abs( threshold - prctile( vec_max, 100*(1-alpha) ) ) < 1e-12 )

rng(2)
berns = 2*(binornd(1, 0.5, nsubj, nperm) - 1/2);

%% Stored permutations are the permuted t-statistics
assert( isequal( size(store), [prod(dim), nperm] ) )
assert( max(abs( store(:,1) - tstat_orig(:) )) < 1e-10 )
data_perm = data.*reshape( berns(:,2), [1,1,nsubj] );
tstat_perm = mvtstat(data_perm);
assert( max(abs( store(:,2) - tstat_perm(:) )) < 1e-10 )

%% No stored permutations by default
rng(2)
[threshold2, vec_max2, store2] = perm_cluster( data, mask, CDT, conn, alpha, nperm, 0 );
assert( isequal( vec_max2, vec_max ) && threshold2 == threshold )
assert( isnan( store2 ) )

%% Default alpha (0.05), nperm (1000) and 2D connectivity (8)
rng(2)
[threshold_def, vec_def] = perm_cluster( data(1:5,1:5,:), ones(5,5), CDT );
assert( numel(vec_def) == 1000 )
assert( abs( threshold_def - prctile( vec_def, 95 ) ) < 1e-12 )

%% The maximum cluster sizes are correct
% (numOfConComps is wrong when all clusters have the same size, e.g. when
% there is only one cluster, so these checks can fail)
assert( vec_max(1) == maxsize(tstat_orig), ...
    'perm_cluster: wrong maximum cluster size for the original data' )
assert( all( vec_max == round(vec_max) ), ...
    'perm_cluster: the maximum cluster sizes are not integers' )
for I = 2:nperm
    data_perm = data.*reshape( berns(:,I), [1,1,nsubj] );
    assert( vec_max(I) == maxsize( mvtstat(data_perm) ), ...
        'perm_cluster: wrong maximum cluster size for a permutation' )
end
mask2 = zeros(dim); mask2(1:4, 1:4) = 1;
rng(2)
[~, vec_mask] = perm_cluster( data, mask2, CDT, conn, alpha, nperm, 0 );
assert( vec_mask(1) == maxsize( nan2zero(tstat_orig).*mask2 ), ...
    'perm_cluster: wrong maximum cluster size in a mask' )

%% No suprathreshold voxels in the original data
% The threshold is NaN (with a warning) and all the outputs are returned.
rng(2)
try
    [thr_none, vec_none, store_none] = perm_cluster( data, mask, 100, conn, alpha, 5, 0 );
    ok = isnan( thr_none ) && isequal( vec_none, zeros(1,5) );
catch
    ok = 0;
end
assert( ok == 1, 'perm_cluster does not return all its outputs when no cluster forms' )
