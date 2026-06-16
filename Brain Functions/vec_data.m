function [ out ] = vec_data( data, mask )
% VEC_DATA extracts in-mask voxel data from an image array into a matrix.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  data     D+1 dimensional array of size [spatial_dims, nsubj], where the
%           last dimension indexes subjects
%  mask     D-dimensional binary array identifying in-mask voxels; non-zero
%           entries select which voxels are extracted
%--------------------------------------------------------------------------
% OUTPUT
% out      nvox by nsubj matrix where nvox = sum(mask(:) > 0)
%--------------------------------------------------------------------------
% EXAMPLES
% a = randn(10,10,50);
% vec_data(a, ones(10,10))
% a = randn(100,50);
% vec_data(a, ones(1,100))
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
s_data = size(data);
D = length(s_data) - 1;
nsubj = s_data(end);
out = zeros(sum(mask(:)), nsubj);

variable_index = repmat( {':'}, 1, D );

for I = 1:nsubj
    variable_index{D+1} = I;
    img = data(variable_index{:});
    out(:,I) = img(mask>0);
end

end

