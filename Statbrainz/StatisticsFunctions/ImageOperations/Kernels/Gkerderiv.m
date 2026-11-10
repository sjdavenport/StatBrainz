function out = Gkerderiv(x, FHWM)
% GKERDERIV computes the first derivative of the 1D Gaussian kernel.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  x       a vector or matrix of values at which to evaluate the derivative
%  FHWM    the FWHM of the Gaussian kernel in voxels
%--------------------------------------------------------------------------
% OUTPUT
%  out     the first derivative of the Gaussian kernel evaluated at x
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
sigma2 = FWHM2sigma(FHWM)^2;
out = (-x/sigma2).*exp(-x.^2/(2*sigma2))/sqrt(2*pi*sigma2);
end
