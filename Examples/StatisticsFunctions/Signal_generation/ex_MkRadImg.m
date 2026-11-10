%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the MkRadImg function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Distances to the origin on a small 2 x 2 x 2 grid
MkRadImg([2,2,2], [0,0,0])

%%
% A 2D disc of radius 20
Img = double(MkRadImg([100, 100], [50.5, 50.5]) <= 20);
imagesc(Img)

%%
% A 3D ball: slices further from the centre give a smaller disc
Img = double(MkRadImg([60, 60, 60], [30.5, 30.5, 30.5]) <= 20);
subplot(1,2,1); imagesc(Img(:,:,30))
subplot(1,2,2); imagesc(Img(:,:,45))
