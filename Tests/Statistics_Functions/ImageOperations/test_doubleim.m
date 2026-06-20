%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the doubleim function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Example 1: Duplicate and expand a 3D matrix
orig_data = rand(91, 109, 91);  % Create a random 3D matrix
new_data = doubleim(orig_data); % Double its dimensions
