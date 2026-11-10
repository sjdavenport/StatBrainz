%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the plotImagesInTile function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Write some images to a temporary folder
cmaps = {'parula', 'hot', 'gray', 'jet'};
imagePaths = cell(1, 4);
for I = 1:4
    rng(I)
    im = uint8(255*ind2rgb(randi(64, 40, 60), feval(cmaps{I}, 64)));
    imagePaths{I} = fullfile(tempdir, ['plotImagesInTile_ex', num2str(I), '.png']);
    imwrite(im, imagePaths{I});
end

%% Four images in a 2 by 2 layout
plotImagesInTile(imagePaths, 2, 2);

%% Three images in a 2 by 2 layout (one tile is empty)
plotImagesInTile(imagePaths(1:3), 2, 2);

%% Four images in one row
plotImagesInTile(imagePaths, 1, 4);
