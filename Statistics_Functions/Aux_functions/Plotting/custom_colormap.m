function cmap = custom_colormap(color1, color2, num_colors)
    % custom_colormap creates a colormap interpolating between two RGB colors
    % color1: 1x3 array for the first RGB color (e.g., [1, 1, 0] for yellow)
    % color2: 1x3 array for the second RGB color (e.g., [0.5, 0, 0.5] for purple)
    % num_colors: Number of levels in the colormap (default is 64)

    if nargin < 3
        num_colors = 64;  % Default number of colors if not provided
    end
    
    % Generate the colormap by interpolating between color1 and color2
    cmap = [linspace(color1(1), color2(1), num_colors)', ...
            linspace(color1(2), color2(2), num_colors)', ...
            linspace(color1(3), color2(3), num_colors)'];
end