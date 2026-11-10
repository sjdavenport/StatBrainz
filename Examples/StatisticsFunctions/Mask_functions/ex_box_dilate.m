%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the box_dilate function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Dilate a single voxel with a 3 x 3 box
mask = zeros(5); mask(3,3) = 1;
box_dilate( mask, 1 )

%%
% A larger radius gives a 5 x 5 box
mask = zeros(9); mask(5,5) = 1; mask(2,8) = 1;
box_dilate( mask, 2 )

%%
% 3D dilation of a random mask
rng(1)
mask = rand(20,20,20) > 0.995;
dilated = box_dilate( mask, 1 );
subplot(1,2,1); imagesc(mask(:,:,10))
subplot(1,2,2); imagesc(dilated(:,:,10))
