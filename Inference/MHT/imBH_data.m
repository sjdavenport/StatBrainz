function [rejection_ind, n_rejections] = imBH_data( data, mask )
% imBH(data, mask) performs two sided multiple hypothesis correction using
% the Benjamini-Hochberg (BH) procedure on the data and mask provided.
% 
% INPUTS:
% Mandatory
%   data: a dim by nsubj array
% Optional
%   mask: a logical mask indicating which p-values in the data should be c
%         onsidered for correction
% OUTPUT:
% rejection_ind: a logical array indicating which hypotheses in the data 
%               are rejected after correction using the BH procedure.
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

