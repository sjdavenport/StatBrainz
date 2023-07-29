function [ out ] = vec_data( data, mask )
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
% a = randn(10,10,50);
% vec_data(a, ones(10,10))
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

