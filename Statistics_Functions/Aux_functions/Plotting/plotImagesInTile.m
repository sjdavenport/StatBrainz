function plotImagesInTile(imagePaths, numRows, numCols)
    % plotImagesInTile - Plots images in a custom tiled layout using imagesc
    %
    % Syntax:
    %   plotImagesInTile(imagePaths, numRows, numCols)
    %
    % Inputs:
    %   imagePaths - Cell array of strings, each specifying the path to an image
    %   numRows    - Number of rows in the tile layout
    %   numCols    - Number of columns in the tile layout
    %
    % Example:
    %   imagePaths = {'image1.png', 'image2.png', 'image3.png'};
    %   plotImagesInTile(imagePaths, 2, 2);

    % Validate inputs
    numImages = length(imagePaths);
    if numImages > numRows * numCols
        error('The number of images exceeds the available tiles.');
    end

    % Initialize fullscreen figure
    figure('Units', 'normalized', 'OuterPosition', [0 0 1 1]);
    set(gca, 'Visible', 'off'); % Turn off the default axes
    axis off;

    % Define separate width and height margins
    widthMargin = 0.1;  % Horizontal margin between tiles
    heightMargin = 0; % Vertical margin between tiles

    % Calculate tile dimensions
    tileWidth = (1 - (numCols + 1) * widthMargin) / numCols;
    tileHeight = (1 - (numRows + 1) * heightMargin) / numRows;

    % Loop through images and plot them
    for i = 1:numImages
        % Read image
        img = imread(imagePaths{i});

        % Calculate position
        row = floor((i - 1) / numCols); % Row index (0-based)
        col = mod((i - 1), numCols);    % Column index (0-based)
        xPos = widthMargin + col * (tileWidth + widthMargin);
        yPos = 1 - (row + 1) * (tileHeight + heightMargin);

        % Plot image using imagesc
        axes('Position', [xPos, yPos, tileWidth, tileHeight]); % Create custom axes
        imagesc(img);
        axis off; % Turn off axes for this tile
        axis image; % Maintain aspect ratio
    end
end
