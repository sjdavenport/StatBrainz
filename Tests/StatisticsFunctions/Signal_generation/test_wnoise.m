%% test_wnoise
% Tests for wnoise: white noise arrays of several distributions.
%--------------------------------------------------------------------------

%% Default is one realisation of Gaussian noise
rng(0); a = wnoise( [4 2 3] );
rng(0); b = randn( [4 2 3] );
assert( isequal( a, b ) )

%% Size is [masksize, fibersize], also for a column masksize
assert( isequal( size( wnoise( [5 5], 10 ) ), [5 5 10] ) )
assert( isequal( size( wnoise( [5; 6], 3 ) ), [5 6 3] ) )
assert( isequal( size( wnoise( [5 6], [2 3] ) ), [5 6 2 3] ) )

%% 'normal' and 'N' give the same draw as randn
rng(1); a = wnoise( [3 3], 2, 'normal' );
rng(1); b = randn( [3 3 2] );
assert( isequal( a, b ) )

%% Uniform noise is rand - 1/2
rng(2); a = wnoise( [10 10], 5, 'U' );
rng(2); b = rand( [10 10 5] ) - 1/2;
assert( isequal( a, b ) )
assert( all( abs(a(:)) <= 1/2 ) )

%% Laplacian noise of scale 2 has mean 0 and variance 2*2^2 = 8
rng(3); a = wnoise( [100 100], 10, 'L', 2 );
assert( abs( mean(a(:)) ) < 0.05 )
assert( abs( var(a(:)) - 8 ) < 0.3 )

%% Skew noise has mean 0 and variance 1; S2 has variance 2
rng(4); a = wnoise( [100 100], 10, 'S' );
assert( abs( mean(a(:)) ) < 0.02 && abs( var(a(:)) - 1 ) < 0.05 )
assert( min(a(:)) >= -1/sqrt(2) )
rng(5); a = wnoise( [100 100], 10, 'S2' );
assert( abs( mean(a(:)) ) < 0.03 && abs( var(a(:)) - 2 ) < 0.1 )

%% t noise with 10 df has variance 10/8
rng(6); a = wnoise( [100 100], 10, 'T', 10 );
assert( isequal( size(a), [100 100 10] ) )
assert( abs( mean(a(:)) ) < 0.02 && abs( var(a(:)) - 1.25 ) < 0.05 )

%% Pearson noise has the right size, mean 0 and variance 1
rng(7); a = wnoise( [50 50], 20, 'P' );
assert( isequal( size(a), [50 50 20] ) )
assert( abs( mean(a(:)) ) < 0.03 && abs( var(a(:)) - 1 ) < 0.05 )

%% Bad masksize or unknown field type gives an error
bad = { {'abc'}, {ones(2,2)}, {[3 3], 1, 'Q'} };
for I = 1:length(bad)
    err = 0;
    try
        wnoise( bad{I}{:} );
    catch
        err = 1;
    end
    assert( err == 1 )
end
