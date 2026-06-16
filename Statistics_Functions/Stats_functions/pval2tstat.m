function tstat = pval2tstat( pval, df )
% PVAL2TSTAT( pval, df ) converts p-values to t-statistics using the
% inverse t-distribution.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  pval   an array of p-values.
%  df     degrees of freedom.
%--------------------------------------------------------------------------
% OUTPUT
%  tstat  an array of t-statistics the same size as pval.

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
if ~exist( 'do2sample', 'var' )
   % Default value
   do2sample = 1;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
tstat = -tinv(pval, df);

end

