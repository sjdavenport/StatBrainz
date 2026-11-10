%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the pearsrnd function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Zero skewness and kurtosis 3 gives a normal draw
rng(1)
[ r, type ] = pearsrnd( 0, 1, 0, 3, 5, 5 )

%% A skewed distribution with mean 2 and standard deviation 3
[ r, type ] = pearsrnd( 2, 3, 1, 4, 10000, 1 );
type
fprintf('sample mean %.3f, sample std %.3f\n', mean(r), std(r));
histogram(r)

%% A light tailed symmetric distribution
[ r, type ] = pearsrnd( 0, 1, 0, 2.5, [50, 50] );
type
imagesc(r); colorbar
