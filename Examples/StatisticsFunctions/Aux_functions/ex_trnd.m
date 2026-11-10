%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the trnd function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Scalar draw
rng(1)
r = trnd( 5 )

%% Compare a large sample to the t density
nu = 4;
r = trnd( nu, 10000, 1 );
x = linspace(-6, 6, 200);
tpdf_x = gamma((nu+1)/2)/(sqrt(nu*pi)*gamma(nu/2)) * (1 + x.^2/nu).^(-(nu+1)/2);
histogram(r(abs(r) < 6), 'Normalization', 'pdf')
hold on
plot(x, tpdf_x, 'LineWidth', 2)
hold off

%% Non-integer degrees of freedom and a size vector
r = trnd( 2.5, [3, 4] )
