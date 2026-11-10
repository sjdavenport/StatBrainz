%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the MySmooth function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Smooth a 2D disc (the maximum of the result is 1)
Img = double(MkRadImg([100, 100], [50.5, 50.5]) <= 10);
sImg = MySmooth(Img, 6);
surf(sImg)

%%
% Anisotropic smoothing with a different FWHM in each direction
sImg = MySmooth(Img, [2, 10]);
imagesc(sImg)

%%
% 3D ball, compare two slices
Img = double(MkRadImg([50, 50, 50], [25.5, 25.5, 25.5]) <= 8);
sImg = MySmooth(Img, 4);
subplot(1,2,1); imagesc(sImg(:,:,25))
subplot(1,2,2); imagesc(sImg(:,:,31))
