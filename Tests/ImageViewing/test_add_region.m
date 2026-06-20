%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the add_region function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[noise, ss] = fast_conv(randn([50,50]), 10, 2);
noise = noise./sqrt(ss)
mask1 = noise > 1;
mask2 = noise > 1.5;
imagesc(noise); hold on
add_region({mask1, mask2}, {'blue', 'red'}); axis off square
