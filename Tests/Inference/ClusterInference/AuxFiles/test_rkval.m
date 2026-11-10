%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the rkval function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Values computed by hand from the definition
%   rk = min_{1<=i<=k} (f_d(i) - i)/f_d(i)
% For d = 1, f_1(i) = i + 1 so rk = 1/(k+1).
% f_2(1) = 4, f_2(2) = 6, f_3(1) = 8.
rng(0)

%% d = 1
for k = 1:6
    assert( abs( rkval(k, 1) - 1/(k+1) ) < 1e-12 )
end

%% d = 2
assert( abs( rkval(1, 2) - 3/4 ) < 1e-12 )
assert( abs( rkval(2, 2) - 2/3 ) < 1e-12 )

%% d = 3 and the default d (3)
assert( abs( rkval(1, 3) - 7/8 ) < 1e-12 )
assert( abs( rkval(1) - 7/8 ) < 1e-12 )
assert( rkval(10) == rkval(10, 3) )

%% rk is in [0,1] and does not increase with k
rks = arrayfun( @(k) rkval(k, 3), 1:30 );
assert( all( rks >= 0 & rks <= 1 ) )
assert( all( diff(rks) <= 0 ) )
