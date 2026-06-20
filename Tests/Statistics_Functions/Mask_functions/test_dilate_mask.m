%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the dilate_mask function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
mask = zeros(5); mask(3,1:5) = 1; mask(1:5,2:3) = 1;
dilate_mask(mask)
dilate_mask(mask,-1)

%%
mask(2,4) = 1; mask(4,4) = 1;
dilate_mask(mask,-1)

%%
mask = zeros(5); mask(:,3) = 1; mask(3,:) = 1;
mask(4,:) = 1; mask(:,4) = 1; mask(2,:) = 1
