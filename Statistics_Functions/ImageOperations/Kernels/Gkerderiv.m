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
% EXAMPLES
% % val = GkerMV(1, 3)
% % deriv = Gkerderiv(1, 3)
% % h = 0.00001;
% % valplushx = GkerMV(1+h, 3);
% % (valplushx - val)/h
% %
% % %Compare to GkerMVderiv
% % GkerMVderiv(0.5, 3)
% % Gkerderiv(0.5, 3)
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
sigma2 = FWHM2sigma(FHWM)^2;
out = (-x/sigma2).*exp(-x.^2/(2*sigma2))/sqrt(2*pi*sigma2);
end
