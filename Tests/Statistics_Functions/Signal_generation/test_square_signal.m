%% test_square_signal
% Tests for square_signal: binary images with square regions of ones.
%--------------------------------------------------------------------------

%% Default centre gives one centred square
signal = square_signal( [10 10], 2 );
expected = zeros(10); expected(3:7, 3:7) = 1;
assert( isequal( signal, expected ) )

%% Two centres with one radius
signal = square_signal( [10 10], 1, {[3,3], [8,8]} );
expected = zeros(10); expected(2:4, 2:4) = 1; expected(7:9, 7:9) = 1;
assert( isequal( signal, expected ) )

%% A radius for each centre
signal = square_signal( [12 12], [1 2], {[3,3], [8,8]} );
expected = zeros(12); expected(2:4, 2:4) = 1; expected(6:10, 6:10) = 1;
assert( isequal( signal, expected ) )

%% 3D cube
signal = square_signal( [6 6 6], 1, {[3 3 3]} );
assert( isequal( size(signal), [6 6 6] ) )
assert( sum(signal(:)) == 27 && all( signal(2:4,2:4,2:4) == 1, 'all' ) )

%% Wrong number of radii gives an error
err = 0;
try
    square_signal( [10 10], [1 2 3], {[3,3], [8,8]} );
catch
    err = 1;
end
assert( err == 1 )
