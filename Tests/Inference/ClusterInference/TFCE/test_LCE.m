%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the LCE function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)
dim = [12,12];
tstat = zeros(dim);
tstat(2:4, 2:4) = 3;      % a strong 3x3 cluster
tstat(9:10, 9) = 1.5;     % a weak 2 voxel cluster
mask1 = zeros(dim); mask1(1:6, 1:6) = 1;
mask2 = zeros(dim); mask2(8:12, 8:12) = 1;
mask3 = zeros(dim); mask3(1, 12) = 1;
H = 2; E = 0.5; conn = 8; dh = 0.1; h0 = 0;

%% The maximum TFCE in each region and the p-values
tf1 = tfce( tstat.*mask1, H, E, conn, dh, h0 );
tf2 = tfce( tstat.*mask2, H, E, conn, dh, h0 );
vec_of_maxima = [ max(tf1(:)) - 1, max(tf2(:)) + 1, max(tf1(:)) + 1, 0 ];
[pvals, maxtf] = LCE( tstat, {mask1, mask2, mask3}, vec_of_maxima, ...
                      H, E, conn, dh, h0, 0 );
assert( isequal( size(pvals), [1,3] ) && isequal( size(maxtf), [1,3] ) )
assert( max(abs( maxtf - [max(tf1(:)), max(tf2(:)), 0] )) < 1e-10 )
assert( max(abs( pvals - [1/4, 3/4, 1] )) < 1e-12 )

%% Default H, E, connectivity, dh and h0 (2, 0.5, 8, 0.1, 0)
[pvals_def, maxtf_def] = LCE( tstat, {mask1, mask2, mask3}, vec_of_maxima );
assert( isequal( pvals_def, pvals ) && max(abs( maxtf_def - maxtf )) < 1e-12 )

%% A single mask that is not in a cell array
[pval, maxtf1] = LCE( tstat, mask1, vec_of_maxima, H, E, conn, dh, h0, 0 );
assert( abs( maxtf1 - maxtf(1) ) < 1e-12 && pval == pvals(1) )

%% Regions given as linear indices are converted to masks
[pvals_idx, maxtf_idx] = LCE( tstat, {find(mask1), find(mask2)}, ...
                              vec_of_maxima, H, E, conn, dh, h0, 0 );
assert( max(abs( maxtf_idx - maxtf(1:2) )) < 1e-12 )
assert( isequal( pvals_idx, pvals(1:2) ) )

%% NaN values in the t-statistic are set to zero
tstat_nan = tstat; tstat_nan(12,1) = NaN;
[~, maxtf_nan] = LCE( tstat_nan, {mask1, mask2}, vec_of_maxima, H, E, conn, dh, h0, 0 );
assert( max(abs( maxtf_nan - maxtf(1:2) )) < 1e-12 )

%% 3D
tstat3 = zeros(6,6,6); tstat3(2:3, 2:3, 2:3) = 2;
mask3D = zeros(6,6,6); mask3D(1:4, 1:4, 1:4) = 1;
tf3 = tfce( tstat3, H, E, 26, dh, h0 );
[pval3, maxtf3] = LCE( tstat3, {mask3D}, [0, 1e6], H, E, 26, dh, h0, 0 );
assert( abs( maxtf3 - max(tf3(:)) ) < 1e-10 && pval3 == 0.5 )

%% Error for region masks with 2 columns
try
    LCE( tstat, {ones(12,2)}, vec_of_maxima, H, E, conn, dh, h0, 0 );
    errored = 0;
catch
    errored = 1;
end
assert( errored == 1 )
