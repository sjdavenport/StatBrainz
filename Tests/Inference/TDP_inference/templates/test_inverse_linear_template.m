%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the inverse_linear_template function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)

%% Known values
out = inverse_linear_template( [0.01, 0.1, 0.5, 1], 4, 100 );
assert( max(abs( out - [0.25, 2.5, 12.5, 25] )) < 1e-12 )

%% Output has the same size as y
y = rand(7,3);
out = inverse_linear_template( y, 2, 10 );
assert( isequal( size(out), [7,3] ) )
assert( max(abs( out(:) - 5*y(:) )) < 1e-12 )

%% Inverse of the linear template: t_k(alpha) = alpha*k/m maps back to alpha
alpha = 0.3; m = 50;
template = linear_template( alpha, 9, m );   % alpha*(1:10)/m
for k = 1:10
    assert( abs( inverse_linear_template( template(k), k, m ) - alpha ) < 1e-12 )
end
