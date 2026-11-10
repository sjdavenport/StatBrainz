function out = Gkerderiv2(x, FHWM)
% GKERDERIV2 computes the second derivative of the 1D Gaussian kernel.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  x       a vector or matrix of values at which to evaluate the second derivative
%  FHWM    the FWHM of the Gaussian kernel in voxels
%--------------------------------------------------------------------------
% OUTPUT
%  out     the second derivative of the Gaussian kernel evaluated at x
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------
sigma2 = FWHM2sigma(FHWM)^2;
out = (-1/sigma2 + x.^2/sigma2^2).*exp(-x.^2/(2*sigma2))/sqrt(2*pi*sigma2);
end
