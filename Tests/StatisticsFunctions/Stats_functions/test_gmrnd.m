%% test_gmrnd
% Tests for gmrnd: random samples from a Gaussian mixture.
%--------------------------------------------------------------------------
rng(0)

%% Output is a num_samples x 1 vector
data = gmrnd( 50, [0.5 0.5], [0 0], [1 7] );
assert( isequal( size(data), [50 1] ) )

%% One component has the right mean and standard deviation
data = gmrnd( 1e5, 1, 3, 2 );
assert( abs( mean(data) - 3 ) < 0.03 && abs( std(data) - 2 ) < 0.03 )

%% Zero standard deviations give only the means
data = gmrnd( 200, [0.5 0.5], [1 2], [0 0] );
assert( all( data == 1 | data == 2 ) )

%% Weights that do not sum to 1 or lengths that differ give errors
bad = { {10, [0.5 0.6], [0 0], [1 1]}, {10, [0.5 0.5], [0 0 0], [1 1]} };
for I = 1:length(bad)
    err = 0;
    try
        gmrnd( bad{I}{:} );
    catch
        err = 1;
    end
    assert( err == 1 )
end

%% Mixture weights give the proportions of the components
data = gmrnd( 1e5, [0.3 0.7], [-100 100], [1 1] );
assert( abs( mean( data < 0 ) - 0.3 ) < 0.01 )
assert( abs( mean( data( data > 0 ) ) - 100 ) < 0.05 )

%% Empirical CDF matches gmcdf
w = [0.2 0.8]; m = [-2 1]; s = [0.5 1];
data = gmrnd( 1e5, w, m, s );
assert( abs( mean( data <= 0 ) - gmcdf( 0, w, m, s ) ) < 0.01 )
