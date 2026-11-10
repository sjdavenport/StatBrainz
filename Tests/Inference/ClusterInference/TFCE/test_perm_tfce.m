%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the perm_tfce function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The sign flips are drawn with binornd after all the other computations,
% so they can be drawn again with the same seed to check the output.
dim = [8,8]; nsubj = 10; nperm = 20;
H = 2; E = 0.5; conn = 8; dh = 0.1; h0 = 0; alpha = 0.1;
rng(1)
data = randn([dim, nsubj]);
data(3:5, 3:5, :) = data(3:5, 3:5, :) + 1.5;
mask = ones(dim);

%% Output sizes and the first entry is the original TFCE maximum
rng(2)
[threshold, vec_of_maxima, store] = perm_tfce( data, mask, H, E, conn, dh, h0, ...
                                               alpha, nperm, 0, 1 );
tf_orig = tfce( mvtstat(data), H, E, conn, dh, h0 );
assert( isscalar(threshold) )
assert( isequal( size(vec_of_maxima), [1,nperm] ) )
assert( abs( vec_of_maxima(1) - max(tf_orig(:)) ) < 1e-10 )
assert( all( vec_of_maxima >= 0 ) )

%% The threshold is the 100(1-alpha) percentile of the maxima
assert( abs( threshold - prctile( vec_of_maxima, 100*(1-alpha) ) ) < 1e-12 )

%% Each maximum is the TFCE maximum of the sign flipped data
rng(2)
berns = 2*(binornd(1, 0.5, nsubj, nperm) - 1/2);
for I = 2:4
    data_perm = data.*reshape( berns(:,I), [1,1,nsubj] );
    tf_perm = tfce( mvtstat(data_perm), H, E, conn, dh, h0 );
    assert( abs( vec_of_maxima(I) - max(tf_perm(:)) ) < 1e-10 )
end

%% The same seed gives the same result
rng(2)
[threshold2, vec_of_maxima2] = perm_tfce( data, mask, H, E, conn, dh, h0, alpha, nperm, 0 );
assert( isequal( vec_of_maxima2, vec_of_maxima ) && threshold2 == threshold )

%% No stored permutations by default
rng(2)
[~, ~, store_default] = perm_tfce( data, mask, H, E, conn, dh, h0, alpha, nperm, 0 );
assert( isnan( store_default ) )

%% Default alpha (0.05) and default nperm (1000)
rng(2)
[threshold_def, vec_def] = perm_tfce( data(1:4,1:4,:), ones(4,4), H, E, conn, dh, h0 );
assert( numel(vec_def) == 1000 )
assert( abs( threshold_def - prctile( vec_def, 95 ) ) < 1e-12 )

%% A mask: voxels outside the mask do not count
mask2 = zeros(dim); mask2(1:5, 1:5) = 1;
rng(2)
[~, vec_mask] = perm_tfce( data, mask2, H, E, conn, dh, h0, alpha, nperm, 0 );
tf_mask = tfce( nan2zero(mvtstat(data)).*mask2, H, E, conn, dh, h0 );
assert( abs( vec_mask(1) - max(tf_mask(:)) ) < 1e-10 )

%% Stored permutations are the permuted t-statistics
% The help says that the third output stores the permuted t-statistics
% (as in perm_cluster): column I is the t-statistic of permutation I.
assert( isequal( size(store), [prod(dim), nperm] ) )
tstat_orig = mvtstat(data);
assert( max(abs( store(:,1) - tstat_orig(:) )) < 1e-10 )
data_perm = data.*reshape( berns(:,2), [1,1,nsubj] );
tstat_perm = mvtstat(data_perm);
assert( max(abs( store(:,2) - tstat_perm(:) )) < 1e-10, ...
    'perm_tfce stores the TFCE image, not the t-statistic, for permutations 2:nperm' )
