function sImg = MySmooth(Img,FWHM)
% MYSMOOTH smooths the image Img using a separable Gaussian kernel. It also
% normalizes the resulting image so that the highest value of the signal is
% 1.
%--------------------------------------------------------------------------
% ARGUMENTS
% Img   An array of 1s and 0s. 1s indicate where we would like the signal
%       to be. Can be a 2d or a 3d array.
% FWHM  A 1x2 or 1x3 vector that is the smoothness in terms of the FWHM,
%       ie FWHM = [FWHM_x, FWHM_y, FWHM_z]: the FWHM in each of the x, y and
%       z directions. Taking FWHM = 0 means that no smoothing is done.
%--------------------------------------------------------------------------
% OUTPUT
% sImg  An array of the same dimensions of Img that has been smoothed
%       according to the degree of smoothness specified by FWHM.
%--------------------------------------------------------------------------
% EXAMPLES
% 2d version
% sImg = MySmooth(double(MkRadImg([256, 256],[128.5,128.5]) <= 20), 10);
% surf(sImg);
%
% 3d version
% sImg = MySmooth(double(MkRadImg([256, 256, 256],[128.5,128.5, 128.5]) <= 20), 10);
% surf(sImg(:,:,128));
% surf(sImg(:,:,109));
%--------------------------------------------------------------------------
% SEE ALSO
% fast_conv

Dim     = size(Img); %Calculate the dimensions of the Image.
nDim    = length(Dim); %Calculate the number of dimensions.

%If only 1 smoothing parameter given smooth the same in every direction.
if length(FWHM) == 1
    FWHM = repmat(FWHM, 1, nDim);
end

if any(FWHM)
    % Separable-Gaussian smoothing via the in-repo fast_conv. This replaces
    % the original SepKernel/fconv (2D) and spm_smooth (3D) paths, so no
    % RFTtoolbox or SPM is required.
    sImg = fast_conv( double(Img), FWHM, nDim );
    sImg = sImg/max(sImg(:));
else
    %Note need double here to convert from logical to a vector.
    sImg = Img/max(double(Img(:)));
end

%Note that you divide by the maximum above so that you can control the
%magnitude of the signal externally to this function. So mag in the parent
%function SpheroidSignal is the value that the highest signal takes.

%This seems a bit arbitrary.
%sImg(sImg(:)<0.05) = 0;

return
