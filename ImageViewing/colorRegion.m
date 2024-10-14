function colored_region_mask = colorRegion(region_mask, color)
% colorRegion - function that takes in a binary region_mask and a color name and returns the corresponding colored region mask
%
% Syntax:  colored_region_mask = colorRegion(region_mask, color)
%
% Inputs:
%    region_mask - binary image of size [r,c]
%    color - string containing the name of the color to be applied on the region_mask
%
% Outputs:
%    colored_region_mask - colored region mask of size [r,c,3]
%
% Example:
%    color = 'red';
%    colored_region_mask = colorRegion(region_mask, color);
%
% Supported colors:
%    'red', 'green', 'blue', 'yellow', 'magenta', 'white', 'black', 'gray'
[r,c] = size(region_mask);
colored_region_mask = zeros([r,c,3]);

if ischar(color)
    switch color
        case 'red'
            colored_region_mask(:,:,1) = region_mask;
        case 'green'
            colored_region_mask(:,:,2) = region_mask;
        case 'blue'
            colored_region_mask(:,:,3) = region_mask;
        case 'yellow'
            colored_region_mask(:,:,1) = region_mask;
            colored_region_mask(:,:,2) = region_mask;
        case 'cyan'
            colored_region_mask(:,:,2) = region_mask;
            colored_region_mask(:,:,3) = region_mask;
        case 'magenta'
            colored_region_mask(:,:,1) = region_mask;
            colored_region_mask(:,:,3) = region_mask;
        case 'gray'
            colored_region_mask(:,:,1) = region_mask * 0.5;
            colored_region_mask(:,:,2) = region_mask * 0.5;
            colored_region_mask(:,:,3) = region_mask * 0.5;
        case 'grey'
            colored_region_mask(:,:,1) = region_mask * 0.5;
            colored_region_mask(:,:,2) = region_mask * 0.5;
            colored_region_mask(:,:,3) = region_mask * 0.5;
        case 'white'
            colored_region_mask(:,:,1) = region_mask;
            colored_region_mask(:,:,2) = region_mask;
            colored_region_mask(:,:,3) = region_mask;
        case 'black'
            colored_region_mask(:,:,1) = region_mask*0;
            colored_region_mask(:,:,2) = region_mask*0;
            colored_region_mask(:,:,3) = region_mask*0;
        otherwise
            colored_region_mask(:,:,1) = region_mask;
    end
elseif isnan(color) 
    colored_region_mask(:,:,1) = region_mask;
else
    colored_region_mask(:,:,1) = color(1)*region_mask;
    colored_region_mask(:,:,2) = color(2)*region_mask;
    colored_region_mask(:,:,3) = color(3)*region_mask;
end

end
