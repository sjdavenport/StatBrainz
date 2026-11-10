%% test_sigma2FWHM
% Tests of the sigma2FWHM function.
%--------------------------------------------------------------------------

%% Known value for sigma = 1
assert(abs(sigma2FWHM(1) - 2.354820045030949) < 1e-12)

%% Linear in sigma
assert(abs(sigma2FWHM(3) - 3*sigma2FWHM(1)) < 1e-12)
assert(sigma2FWHM(0) == 0)

%% The FWHM is the width where the Gaussian is half its maximum
sigma = 2.5;
FWHM = sigma2FWHM(sigma);
assert(abs(exp(-(FWHM/2)^2/(2*sigma^2)) - 0.5) < 1e-12)

%% Vector input gives output of the same size
sigma = [1, 2; 3, 4];
FWHM = sigma2FWHM(sigma);
assert(isequal(size(FWHM), [2, 2]))
assert(max(abs(FWHM(:) - sqrt(8*log(2))*sigma(:))) < 1e-12)
