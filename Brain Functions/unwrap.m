function [ out ] = unwrap( data, mask )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

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

