%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the lcdf function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
x = -5:0.1:5;
mu = 0; b = 1;
cdf = lcdf(x, mu, b);
fprintf('lcdf: cdf range [%g, %g] (expect ~[0, 1])\n', min(cdf), max(cdf));
plot(x, cdf)
title('Laplace CDF')
