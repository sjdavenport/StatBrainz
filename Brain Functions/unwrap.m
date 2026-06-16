function [ out ] = unwrap( data, mask )
% UNWRAP maps vectorized voxel data back into a brain image array.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  data     nvox by nsubj matrix (or a cell array of such matrices) of
%           voxel values to be placed back into image space
%  mask     a D-dimensional array whose non-zero entries identify the
%           voxels corresponding to rows of data
%--------------------------------------------------------------------------
% OUTPUT
% out      array of size [size(mask), nsubj] with data placed at the
%          in-mask voxels and zeros elsewhere; if data is a cell array,
%          out is a cell array of the same length
%--------------------------------------------------------------------------
% EXAMPLES
% MNImask = imgload('MNImask') > 0;
% random_data = randn(size(MNImask));
% random_data = fconv(random_data, 4, 3);
% random_data_vec = random_data(MNImask);
% unwrapped_data = unwrap(random_data_vec, MNImask);
% subplot(2,1,1)
% imagesc(random_data(:,:,50))
% subplot(2,1,2)
% imagesc(unwrapped_data(:,:,50))
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------
if iscell(data)
    out = cell(1,length(data));
    for I = 1:length(data)
        out{I} = unwrap(data{I},mask);
    end
    return
end

%%  Add/check optional values
%--------------------------------------------------------------------------
nsubj = size(data,2);

if nsubj > 500
    warning('nsubj > 500!')
end

%%  Main Function Loop
%--------------------------------------------------------------------------
out = zeros([size(mask), nsubj]);
D = length(size(mask));
variable_index = repmat( {':'}, 1, D );

for I = 1:nsubj
    img = zeros(size(mask));
    img(mask>0) = data(:,I);
    variable_index{D+1} = I;
    out(variable_index{:}) = img;
end

end

