%% test_plotImagesInTile
% Smoke tests of the plotImagesInTile function.
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')

imagePaths = cell(1, 4);
for I = 1:4
    imagePaths{I} = fullfile(tempdir, ['test_plotImagesInTile', num2str(I), '.png']);
    imwrite(uint8(randi(255, 8, 10, 3)), imagePaths{I});
end

%% Four images in a 2 by 2 layout
plotImagesInTile(imagePaths, 2, 2);
close all

%% Fewer images than tiles
plotImagesInTile(imagePaths(1:3), 2, 2);
close all

%% One row
plotImagesInTile(imagePaths, 1, 4);
close all

%% Error if there are more images than tiles
errored = 0;
try
    plotImagesInTile(imagePaths, 1, 3);
catch
    errored = 1;
end
assert(errored == 1)
close all

for I = 1:4
    delete(imagePaths{I});
end
