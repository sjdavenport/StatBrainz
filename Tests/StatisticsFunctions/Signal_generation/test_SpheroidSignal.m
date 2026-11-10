%% test_SpheroidSignal
% Tests for SpheroidSignal: a (smoothed) disc/ball of magnitude mag.
%--------------------------------------------------------------------------
tol = 1e-10;

%% Without smoothing the signal is mag inside the disc and 0 outside
Sig = SpheroidSignal( [20 20], 3, 2, 0 );
expected = 2*double( MkRadImg( [20 20], [10.5 10.5] ) <= 3 );
assert( isequal( Sig, expected ) )

%% center_loc moves the signal
Sig = SpheroidSignal( [10 10], 0, 1, 0, [3, 7] );
expected = zeros(10); expected(3,7) = 1;
assert( isequal( Sig, expected ) )

%% With smoothing the maximum is mag and it matches MySmooth
Sig = SpheroidSignal( [40 40], 5, 3, 6 );
assert( abs( max(Sig(:)) - 3 ) < tol )
ref = 3*MySmooth( MkRadImg( [40 40], [20.5 20.5] ) <= 5, 6 );
assert( max( abs( Sig(:) - ref(:) ) ) < tol )

%% 3D signal has the right size and magnitude
Sig = SpheroidSignal( [20 21 22], 4, 1.5, 3 );
assert( isequal( size(Sig), [20 21 22] ) )
assert( abs( max(Sig(:)) - 1.5 ) < tol )
