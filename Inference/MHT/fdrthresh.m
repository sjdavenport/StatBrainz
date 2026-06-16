function thresh = fdrthresh( pvals, pval_rejection_ind, df )
% FDRTHRESH computes the t-statistic threshold corresponding to the maximum
% rejected p-value from a BH procedure.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  pvals             a vector of p-values
%  pval_rejection_ind a logical vector indicating which p-values are rejected
%  df                degrees of freedom for the t-distribution
%--------------------------------------------------------------------------
% OUTPUT
% thresh  the t-statistic threshold corresponding to the largest rejected p-value
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
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
maxp = max(pvals(pval_rejection_ind));
thresh = tinv(maxp, df);

end

