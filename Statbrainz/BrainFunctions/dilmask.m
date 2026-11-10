%% 2D
BW = zeros(9,10);
BW(4:6,4:7) = 1
imshow(imresize(BW,40,'nearest'))
SE = strel('square',3)
BW2 = imdilate(BW,SE)
imshow(imresize(BW2,40,'nearest'))

%% 3D
SE = strel('cube',3)
BW = zeros(6,6,6);
BW(3:4,3:4,3:4) = 1
BW2 = imdilate(BW,SE)
