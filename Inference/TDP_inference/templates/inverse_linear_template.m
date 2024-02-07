function [ out ] = inverse_linear_template( y, k, m )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  y: array of floats of size B x nvoxels giving values to apply the inverse template to
%  k: integer, giving the rejection set index
%  m: integer giving the total number of hypotheses
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
% Copyright (C) - 2021 - Pierre Neuvial
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
out = y * m / k;

end

