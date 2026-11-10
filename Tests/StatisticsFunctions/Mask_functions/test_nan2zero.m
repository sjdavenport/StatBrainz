%% test_nan2zero
% Tests for nan2zero: NaN entries are replaced by val (default 0).
%--------------------------------------------------------------------------

%% Default replaces NaN by 0
assert( isequal( nan2zero( [1, 5.1, 0, NaN, 0.0001] ), [1, 5.1, 0, 0, 0.0001] ) )

%% A custom replacement value
assert( isequal( nan2zero( [NaN 2; 3 NaN], -1 ), [-1 2; 3 -1] ) )

%% Inf is not changed and size is kept
x = NaN(2, 2, 2); x(1) = Inf;
out = nan2zero( x );
assert( isequal( size(out), [2 2 2] ) && out(1) == Inf && sum(out(2:end)) == 0 )

%% Array without NaN is unchanged
x = magic(4);
assert( isequal( nan2zero(x), x ) )

%% Inverse of zero2nan for arrays without NaN
x = [0 1 0 2];
assert( isequal( nan2zero( zero2nan(x) ), x ) )
