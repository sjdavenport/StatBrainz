function [ rejection_ind, nrejections, rejection_locs ] = fdrBH( pvalues, alpha )
% FDRBH( pvalues, alpha ) implements the Benjamini-Hochberg procedure on a
% vector of pvalues, controlling the FDR to a level alpha
%--------------------------------------------------------------------------
% ARGUMENTS
% pvalues       a vector of p-values
% alpha         the significance level, default is 0.05
%--------------------------------------------------------------------------
% OUTPUT
% rejection_ind a logical array with the same size as pvalues such that a
%               given entry is 1 if that point is rejected and 0 otherwise
% nrejections   the total number of rejections
% rejection_locs the locations of the rejections
%--------------------------------------------------------------------------
% EXAMPLES
% nvals = 100; normal_rvs = normrnd(0,1,1,nvals);
% normal_rvs(1:20) = normal_rvs(1:20) + 2;
% pvalues = 1 - normcdf(normal_rvs);
% [ rejection_ind, nrejections, sig_locs ] = fdrBH(pvalues)
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------
if ~exist('alpha', 'var')
    alpha = 0.05;
end

Dim = size(pvalues);

[sorted_pvalues, sort_index] = sort(pvalues(:)');
npvals = length(pvalues(:));

BH_upper = (1:npvals)*alpha/npvals;
    
BH_vector = sorted_pvalues <= BH_upper;
nrejections = find(BH_vector,1,'last');

rejection_locs = sort(sort_index(1:nrejections));

% Initialize a vector of location of rejections
rejection_ind = false(1, prod(Dim));

% Set each rejection to 1
rejection_ind(rejection_locs) = 1;

% Reshape sig_loc_ind so that it has the same size as pvalues
rejection_ind = reshape(rejection_ind, Dim);

% Set the number of rejections to be zero if none are found!
if isempty(nrejections)
    nrejections = 0;
end

end

