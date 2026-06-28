%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the colorRegion function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
region_mask = rand(50,50) > 0.5;
color = 'red';
colored_region_mask = colorRegion(region_mask, color);

% Echo a summary of the result so the test produces visible output.
fprintf('colorRegion returned array of size [%s], class %s\n', ...
    num2str(size(colored_region_mask)), class(colored_region_mask));
