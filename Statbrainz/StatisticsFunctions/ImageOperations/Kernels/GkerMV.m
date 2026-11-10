function val = GkerMV( x, sigma2_or_FWHM, use_fwhm )
% GKERMV( x, sigma2_or_FWHM, use_fwhm ) calculates the Gaussian Kernel given
% multivariate data and the FWHM of the kernel.
%--------------------------------------------------------------------------
% ARGUMENTS
% x                 a D by nevals matrix where each column is a
%                   D-dimensional vector at which to evaluate the kernel.
% sigma2_or_FWHM    If FWHM, it is the FWHM in voxels.
% use_fwhm          0/1 indicating whether to parametrize the kernel in
%                   terms of the FWHM or the variance. Default is 1 ie to
%                   parametrize in terms of the FWHM.
%--------------------------------------------------------------------------
% OUTPUT
% val               a number giving the value of the kernel
%--------------------------------------------------------------------------
% Copyright (C) - 2025 - Samuel Davenport
%--------------------------------------------------------------------------
if nargin < 3
    use_fwhm = 1;
end

if use_fwhm
    sigma2 = FWHM2sigma(sigma2_or_FWHM)^2;
else
    sigma2 = sigma2_or_FWHM;
end

D = size(x, 1);

Sigmainv = (1/sigma2)*eye(D);
val = exp(-sum(x.^2,1)/(2*sigma2))/(sqrt(2*pi*sigma2)^D); %Only this it is Multivariate!
% temp_deriv = -Sigmainv*x; %Without the kernel constant.
% 
% deriv2 = zeros(D^2, size(x,2));
% for I = 1:D
%     for J = 1:I
%         deriv2( D*(I-1) + J, : ) = (temp_deriv(I,:).*temp_deriv(J,:) - Sigmainv(I,J)).*val;
%         deriv2( D*(J-1) + I, : ) = deriv2( D*(I-1) + J, : );
%     end
% end 
% deriv = temp_deriv.*val;

%For the moment just have an isotropic kernel coded. Need to generalize!

end

