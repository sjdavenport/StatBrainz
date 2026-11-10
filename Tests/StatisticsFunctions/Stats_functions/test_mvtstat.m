%% test_mvtstat
% Tests for mvtstat: one sample t-statistic at each voxel.
%--------------------------------------------------------------------------
tol = 1e-10;

%% Known values computed by hand
data = [1 2 3; 2 4 9];   % 2 voxels, 3 subjects
[tstat, xbar, std_dev, cohensd] = mvtstat( data );
assert( max( abs( xbar - [2; 5] ) ) < tol )
assert( max( abs( std_dev - [1; sqrt(13)] ) ) < tol )
assert( max( abs( tstat - sqrt(3)*[2; 5/sqrt(13)] ) ) < tol )
assert( max( abs( cohensd - [2; 5/sqrt(13)] ) ) < tol )

%% 3D data matches mean and std along the last dimension
rng(0); data = randn(4, 5, 10) + 0.3;
[tstat, xbar, std_dev] = mvtstat( data );
assert( isequal( size(tstat), [4 5] ) )
assert( max( abs( xbar - mean(data, 3) ), [], 'all' ) < tol )
assert( max( abs( std_dev - std(data, 0, 3) ), [], 'all' ) < tol )
assert( max( abs( tstat - sqrt(10)*mean(data,3)./std(data,0,3) ), [], 'all' ) < tol )

%% Dim reshapes vectorised data
data = randn(20, 6);
tstat = mvtstat( data, [4 5] );
assert( isequal( size(tstat), [4 5] ) )
assert( max( abs( tstat(:) - mvtstat( data ) ) ) < tol )

%% Single voxel (1 x nsubj) gives a scalar
assert( isscalar( mvtstat( randn(1, 30) ) ) )

%% nansaszeros sets NaN entries to 0, default keeps NaN
data = [zeros(1, 5); randn(1, 5)];
tstat = mvtstat( data );
assert( isnan( tstat(1) ) )
[tstat, ~, ~, cohensd] = mvtstat( data, 2, 1 );
assert( tstat(1) == 0 && cohensd(1) == 0 && ~isnan( tstat(2) ) )
