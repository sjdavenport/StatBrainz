function mask = index2mask( indices, dim )
% INDEX2MASK Converts linear indices to a mask of dimension length(dim)
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%   indices : array
%       A vector of linear indices to be converted.
% Optional
%   dim : vector
%       Dimensions of the output mask (default: [91, 109, 91])
% -------------------------------------------------------------------------
% OUTPUT
%   mask : array
%       A binary array of size dim (default [91, 109, 91]) where the
%       positions specified by the input indices are set to 1 and all
%       other positions are set to 0.
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

