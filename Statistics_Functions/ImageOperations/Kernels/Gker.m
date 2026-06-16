function [val, deriv, deriv2] = Gker( x, sigma2_or_FWHM, use_fwhm )
% GKER( x, sigma2_or_FWHM, use_fwhm ) calculates the Gaussian Kernel given
% data and the variance: sigma2 or FWHM.
%--------------------------------------------------------------------------
% ARGUMENTS
% x                 a vector or matrix of values at which to evaluate the kernel
% sigma2_or_FWHM    the FWHM in voxels (if use_fwhm=1) or the variance sigma^2
% use_fwhm          1 to interpret sigma2_or_FWHM as FWHM (default), 0 for variance
%--------------------------------------------------------------------------
% OUTPUT
% val               the Gaussian kernel evaluated at x
% deriv             the first derivative of the Gaussian kernel at x
% deriv2            the second derivative of the Gaussian kernel at x

%--------------------------------------------------------------------------
% EXAMPLES
% Gker([1.5,2]', 3)
% 
% Gker([1.5,2], 3)
% Gker([1.5,2; 0, 1], 3)
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
if nargin < 3
    use_fwhm = 1;
end

if use_fwhm
    sigma2 = FWHM2sigma(sigma2_or_FWHM)^2;
else
    sigma2 = sigma2_or_FWHM;
end

val = exp(-x.^2/(2*sigma2))/sqrt(2*pi*sigma2);
deriv = (-x/sigma2).*exp(-x.^2/(2*sigma2))/sqrt(2*pi*sigma2); 
% dxh      = -x .* h / nu( 1 )^2;
deriv2 = (-1/sigma2 + x.^2/sigma2^2).*exp(-x.^2/(2*sigma2))/sqrt(2*pi*sigma2);

end

