%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the linear_template function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)

%% Known values
template = linear_template( 0.4, 5, 1000 );
assert( isequal( size(template), [1,6] ) )
assert( max(abs( template - 0.4*(1:6)/1000 )) < 1e-15 )

%% k = 0 gives a single value alpha/m
assert( abs( linear_template( 0.05, 0, 10 ) - 0.005 ) < 1e-15 )

%% The template is linear and increasing
template = linear_template( 0.1, 20, 50 );
assert( all( diff(template) > 0 ) )
assert( max(abs( diff(template) - 0.1/50 )) < 1e-15 )

%% alpha = 0 gives zeros
assert( isequal( linear_template( 0, 3, 10 ), zeros(1,4) ) )
