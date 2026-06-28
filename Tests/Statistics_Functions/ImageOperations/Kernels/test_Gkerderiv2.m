%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the Gkerderiv2 function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
x = -3:0.1:3;
FWHM = 3;
out = Gkerderiv2(x, FWHM);
fprintf('Gkerderiv2: %d inputs -> output range [%g, %g]\n', numel(x), min(out), max(out));
plot(x, out)
title('Second derivative of Gaussian kernel')
