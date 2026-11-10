%% test_bernstd
% Tests for bernstd: CLT confidence intervals for Bernoulli proportions.
%--------------------------------------------------------------------------
tol = 1e-8;

%% Known value for p = 0.5, N = 100, level 0.95
[interval, se] = bernstd( 0.5, 100, 0.95 );
assert( abs( se - 0.5*1.959963985/10 ) < tol )
assert( max( abs( interval - [0.5 - se; 0.5 + se] ) ) < tol )

%% Default level is 0.95
[interval2, se2] = bernstd( 0.5, 100 );
assert( isequal( interval2, interval ) && isequal( se2, se ) )

%% Level 0.9 uses the 0.95 normal quantile
[~, se] = bernstd( 0.2, 400, 0.9 );
assert( abs( se - sqrt(0.2*0.8)*1.644853627/20 ) < tol )

%% Vector input gives a 2 x n interval and 1 x n standard errors
p = [0.05, 0.5, 0.9];
[interval, se] = bernstd( p, 1000 );
assert( isequal( size(interval), [2 3] ) && isequal( size(se), [1 3] ) )
assert( max( abs( se - sqrt(p.*(1-p))*norminv(0.975)/sqrt(1000) ) ) < tol )
assert( max( abs( interval(2,:) - interval(1,:) - 2*se ) ) < tol )

%% p = 0 and p = 1 give zero width
[interval, se] = bernstd( [0 1], 50 );
assert( all( se == 0 ) && isequal( interval, [0 1; 0 1] ) )
