%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the gmcdf function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
x = -5:0.1:5;
weights = [0.5, 0.5];
means = [0, 0];
std_devs = [1, 7];
cdf = gmcdf(x, weights, means, std_devs);
fprintf('gmcdf: cdf range [%g, %g] (expect ~[0, 1])\n', min(cdf), max(cdf));
plot(x, cdf)
