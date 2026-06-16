function [rejection_ind, n_rejections] = imBH_data( data, mask )
% IMBH_DATA performs two-sided multiple hypothesis correction using the
% Benjamini-Hochberg (BH) procedure on raw data within a spatial mask.
% A one-sample t-statistic is computed from the data and converted to
% two-sided p-values before applying BH.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%   data: a Dim by nsubj array of observations
%   mask: a logical spatial mask indicating which locations to consider
%--------------------------------------------------------------------------
% OUTPUT
% rejection_ind   a logical array of size Dim indicating rejected locations
% n_rejections    the total number of rejections
%--------------------------------------------------------------------------
% EXAMPLES
% data = wfield([10,10,20]).field;
% mask = peakgen( 1, 5, 3, [10,10]) > 0.5;
% rejection_ind = imBH_data( data, mask )
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
s_data = size(data);
nsubj = s_data(end);
data_tstat = mvtstat(data);
pvals = 2*(1 - tcdf(abs(data_tstat), nsubj - 1));

pvals2use = pvals(logical(mask));
pval_rejection_ind = fdrBH( pvals2use );

maxp = max(pvals2use(pval_rejection_ind));
if isempty(maxp)
    rejection_ind = zeros(s_data(1:end-1));
else
    rejection_ind = (pvals <= maxp+eps);
end

n_rejections = sum(rejection_ind(:));

end

