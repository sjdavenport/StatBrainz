function template = linear_template(alpha, k, m)
% linear_template(alpha, k, m)
%--------------------------------------------------------------------------
% ARGUMENTS
%  alpha: giving the confidence level in [0, 1]
%  k: integer, giving the rejection set index
%  m: integer giving the total number of hypotheses
%--------------------------------------------------------------------------
% OUTPUT
% template the corresponding value of the template
%--------------------------------------------------------------------------
% EXAMPLES
% linear_template(0.4, 5, 1000)
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
template = (alpha * (1:(k + 1))/ m);

end

