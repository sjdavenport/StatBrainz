% Load the 3D image array
image = imgload('MNImask');

% Create a new figure
figure;

% Set the number of frames in the animation
numFrames = 60;

% Create a y-axis vector
yaxis = [0, 1, 0];

% Loop over each frame
for i = 1:numFrames
    
    % Rotate the image by a fixed amount around the y-axis
    theta = (i-1)*(360/numFrames);
    rotatedImage = imrotate3(image, yaxis, theta, 'nearest', 'crop');
    
    % Display the rotated image
    slice(rotatedImage, [], [], size(rotatedImage, 3)/2);
    shading interp;
    colormap gray;
    
    % Set the axis limits and labels
    axis([1, size(rotatedImage, 1), 1, size(rotatedImage, 2), 1, size(rotatedImage, 3)]);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    
    % Pause briefly to create animation effect
    pause(0.1);
    
end
