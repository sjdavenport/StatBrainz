function [ out ] = inverse_linear_template( y, k, m )
% INVERSE_LINEAR_TEMPLATE applies the inverse of the linear template
% function, mapping template values back to the original p-value scale.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  y: array of floats giving values to apply the inverse template to
%  k: integer, giving the rejection set index
%  m: integer giving the total number of hypotheses
%--------------------------------------------------------------------------
% OUTPUT
% out   array of the same size as y with the inverse template applied
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

