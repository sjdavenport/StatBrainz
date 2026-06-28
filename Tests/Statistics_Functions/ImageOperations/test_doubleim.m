%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the doubleim function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Example 1: Duplicate and expand a 3D matrix
orig_data = rand(91, 109, 91);  % Create a random 3D matrix
new_data = doubleim(orig_data); % Double its dimensions

% Echo a summary of the result so the test produces visible output.
fprintf('doubleim: input size [%s] -> output size [%s]\n', ...
    num2str(size(orig_data)), num2str(size(new_data)));
