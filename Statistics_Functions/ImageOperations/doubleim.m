function [ new_data ] = doubleim( orig_data )
% DOUBLEIM Duplicates and expands the input data by a factor of 2 in each dimension.
%   The function takes an input 3D matrix and duplicates it, expanding it by a factor of 2
%   in each dimension (X, Y, and Z) to create a new 3D matrix.
%
%   Syntax:
%       new_data = doubleim(orig_data)
%
%   ARGUMENTS:
%   Mandatory:
%       orig_data - The original 3D matrix to be duplicated and expanded.
%
%   OUTPUT:
%       new_data - The resulting 3D matrix with doubled dimensions.
%
%   EXAMPLES:
%   % Example 1: Duplicate and expand a 3D matrix
%   orig_data = rand(91, 109, 91);  % Create a random 3D matrix
%   new_data = doubleim(orig_data); % Double its dimensions
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
new_data = zeros([182,218,182]);
for I = 1:2
    for J = 1:2
        for K = 1:2
            new_data(I:2:182, J:2:218, K:2:182) = orig_data;
        end
    end
end

end

