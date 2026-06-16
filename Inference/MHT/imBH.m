function [rejection_ind, n_rejections] = imBH( pvals, mask )
% IMBH performs multiple hypothesis correction using the Benjamini-Hochberg
% (BH) procedure on an image of p-values within a mask.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%   pvals: a spatial array of p-values
%   mask:  a logical mask of the same size as pvals indicating which
%          p-values should be considered for correction
%--------------------------------------------------------------------------
% OUTPUT
% rejection_ind   a logical array with the same size as pvals such that a
%                 given entry is 1 if that hypothesis is rejected
% n_rejections    the total number of rejections
%--------------------------------------------------------------------------
% EXAMPLES
% data = wfield([10,10,20]).field;
% mask = peakgen( 1, 5, 3, [10,10]) > 0.5;
% rejection_ind = imBH( data, mask )
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

if size(pvals) ~= size(mask)
    error('The size of pvals must be the same as the size of mask')
end

%%  Main Function Loop
%--------------------------------------------------------------------------
s_mask = size(mask);
pvals2use = pvals(logical(mask));
pval_rejection_ind = fdrBH( pvals2use );

maxp = max(pvals2use(pval_rejection_ind));
if isempty(maxp)
    rejection_ind = zeros(s_mask);
else
    rejection_ind = (pvals <= maxp+eps);
end

n_rejections = sum(rejection_ind(:));

end

