%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the localized_csi function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)
dim = [12,12];
tstat = zeros(dim);
tstat(2:4, 2:4) = 5;      % a cluster of 9 voxels
tstat(9:10, 9:10) = 5;    % a cluster of 4 voxels
tstat(6, 1) = 5;          % single voxels, so that each region has
tstat(12, 12) = 5;        % clusters of different sizes
mask1 = zeros(dim); mask1(1:6, 1:6) = 1;
mask2 = zeros(dim); mask2(8:12, 8:12) = 1;
mask3 = zeros(dim); mask3(1:6, 8:12) = 1;   % no suprathreshold voxels
vec_of_maxima = [1, 4, 9, 10];

%% Maximum cluster size in each region and the p-values
[pvals, maxsizes] = localized_csi( tstat, {mask1, mask2, mask3}, vec_of_maxima, 8, 3.1, 0 );
assert( isequal( maxsizes, [9, 4, 0] ) )
assert( max(abs( pvals - [2/4, 3/4, 1] )) < 1e-12 )

%% Part of a cluster in a region
mask4 = zeros(dim); mask4(2:3, 2:4) = 1; mask4(6,1) = 1;
[pval, maxsize] = localized_csi( tstat, {mask4}, vec_of_maxima, 8, 3.1, 0 );
assert( maxsize == 6 && pval == 2/4 )

%% A mask that is not in a cell array
[pval, maxsize] = localized_csi( tstat, mask1, vec_of_maxima, 8, 3.1, 0 );
assert( maxsize == 9 && pval == 2/4 )

%% Default connectivity (8 in 2D) and CDT (3.1)
t2 = zeros(dim);
t2(1,1) = 3.2; t2(2,2) = 3.2; t2(3,3) = 3.2;   % 3 voxels on a diagonal
t2(8, 8:9) = 3.2;                              % 2 voxels
t2(8, 10:11) = 3;                              % below the default CDT
[~, maxsize] = localized_csi( t2, {ones(dim)}, vec_of_maxima );
assert( maxsize == 3 )
[~, maxsize] = localized_csi( t2, {ones(dim)}, vec_of_maxima, 4 );
assert( maxsize == 2 )
[~, maxsize] = localized_csi( t2, {ones(dim)}, vec_of_maxima, 8, 2.9 );
assert( maxsize == 4 )

%% NaN values in the t-statistic are ignored
t3 = tstat; t3(6, 12) = NaN;
[~, maxsizes] = localized_csi( t3, {mask1, mask2}, vec_of_maxima, 8, 3.1, 0 );
assert( isequal( maxsizes, [9, 4] ) )

%% 3D: default connectivity is 26
t3D = zeros(5,5,5);
t3D(1,1,1) = 4; t3D(2,2,2) = 4; t3D(3,3,3) = 4;   % corner neighbours
t3D(5,5,4:5) = 4;                               % 2 voxels
[~, maxsize] = localized_csi( t3D, {ones(5,5,5)}, vec_of_maxima );
assert( maxsize == 3 )
[~, maxsize] = localized_csi( t3D, {ones(5,5,5)}, vec_of_maxima, 6, 3.1, 0 );
assert( maxsize == 2 )

%% A region with a single cluster
% (or with clusters that all have the same size)
mask5 = zeros(dim); mask5(1:5, 1:5) = 1;
[pval, maxsize] = localized_csi( tstat, {mask5}, vec_of_maxima, 8, 3.1, 0 );
assert( maxsize == 9 && pval == 2/4, ...
    'localized_csi gives the wrong cluster size for a region with one cluster' )
