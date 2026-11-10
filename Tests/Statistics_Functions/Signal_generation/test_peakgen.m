%% test_peakgen
% Tests for peakgen: sum of (smoothed) spheroid peaks.
%--------------------------------------------------------------------------
tol = 1e-10;

%% Without smoothing the peaks are discs with the given magnitudes
Sig = peakgen( [1,2], 3, [0,0], [100,150], {[40,30], [70,120]} );
[x, y] = ndgrid( 1:100, 1:150 );
expected = 1*( sqrt((x-40).^2 + (y-30).^2) <= 3 ) ...
         + 2*( sqrt((x-70).^2 + (y-120).^2) <= 3 );
assert( isequal( size(Sig), [100, 150] ) )
assert( max( abs( Sig(:) - expected(:) ) ) < tol )

%% A smoothed single peak has maximum Mag and is symmetric about the centre
Sig = peakgen( 1.5, 10, 8, [90, 90] );
assert( isequal( size(Sig), [90, 90] ) )
assert( abs( max(Sig(:)) - 1.5 ) < tol )
assert( max( abs( Sig - flipud(Sig) ), [], 'all' ) < tol )
assert( max( abs( Sig - Sig' ), [], 'all' ) < tol )

%% Smoothing does not move the peak (boundary is handled)
Sig = peakgen( 1, 2, 6, [40, 40], {[12, 25]} );
[~, imax] = max( Sig(:) );
[ix, iy] = ind2sub( size(Sig), imax );
assert( ix == 12 && iy == 25 )

%% Defaults give a 91 x 109 x 91 image with a peak of magnitude 2
Sig = peakgen();
assert( isequal( size(Sig), [91, 109, 91] ) )
assert( abs( max(Sig(:)) - 2 ) < tol )

%% Mag, Rad and Smo with the wrong number of peaks give errors
locs = {[10,10], [20,20]};
bad = { {[1 2 3], 3, 0, [30 30], locs}, {1, [1 2 3], 0, [30 30], locs}, ...
        {1, 3, [0 0 0], [30 30], locs} };
for I = 1:length(bad)
    err = 0;
    try
        peakgen( bad{I}{:} );
    catch
        err = 1;
    end
    assert( err == 1 )
end
