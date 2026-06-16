function FWHM = sigma2FWHM( sigma )
% SIGMA2FWHM converts a Gaussian kernel standard deviation to FWHM.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  sigma    standard deviation of the Gaussian kernel
%--------------------------------------------------------------------------
% OUTPUT
% FWHM     full width at half maximum corresponding to sigma
%--------------------------------------------------------------------------
% EXAMPLES
%
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport.

FWHM = sqrt(8*log(2))*sigma;
end

