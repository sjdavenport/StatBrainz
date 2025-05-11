function mask = index2mask( indices, dim )
% INDEX2MASK Converts linear indices to a mask of dimension length(dim)
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%   indices : array
%       A vector of linear indices to be converted.
% -------------------------------------------------------------------------
% OUTPUT
%   mask : 3D array
%       A 3D binary mask of size [91, 109, 91] where the positions
%       specified by the input indices are set to 1, and all other
%       positions are set to 0.
%--------------------------------------------------------------------------
% EXAMPLES
% % 2D 
%   indices = [100, 2000, 50000];
%   mask = index2mask(indices);
%   % This will create a 3D mask of size [91, 109, 91] with the positions
%   % corresponding to the linear indices 100, 2000, and 50000 set to 1.
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

if ~exist('dim', 'var')
    dim = [91,109,91];
end

%%  Main Function Loop
%--------------------------------------------------------------------------
mask = zeros(dim);
mask(indices) = 1;

end

