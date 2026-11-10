function pval_vec = distbn2pval( distbn, value_vec )
% DISTBN2PVAL( distbn, value_vec ) computes empirical p-values for each
% entry of value_vec against a reference distribution distbn.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  distbn      a numeric vector representing the reference distribution.
%  value_vec   a numeric vector of values for which to compute p-values.
%--------------------------------------------------------------------------
% OUTPUT
%  pval_vec    a 1-by-length(value_vec) vector of empirical p-values;
%              each entry is the proportion of distbn >= value_vec(I).
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

