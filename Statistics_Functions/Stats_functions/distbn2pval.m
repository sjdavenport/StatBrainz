function pval_vec = distbn2pval( distbn, value_vec )
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
% Copyright (C) - 2023 - Samuel Davenport
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
pval_vec = zeros(1, length(value_vec));
nindist = length(distbn);
for I = 1:length(value_vec)
    % Augment the distribution to include the current value to avoid zero
    % pvalues
    % tempdist = [distbn, value_vec(I)]; 
    % Ask Jelle about the above!!

    % Compute the p-value
    pval_vec(I) = sum(distbn >= value_vec(I))/(nindist);
end

end

