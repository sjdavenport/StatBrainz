function [ lower_band, upper_band, threshold ] = scopes( data, nblocks, nboot, alpha, show_loader, sigmahat )
% SCOPES Computes simultaneous confidence bands for a data field using the SCOPES method.
%--------------------------------------------------------------------------
% ARGUMENTS:
%   - data: Data field of size dim by nsubj.
%   - nblocks: Number of blocks to use in the permutation; default is nsubj.
%   - nboot: Number of bootstrap samples.
%   - alpha: Significance level for confidence intervals.
%   - show_loader: Flag to display progress loader during computation.
%   - sigmahat: Optional pre-computed standard deviation field of size dim;
%               if provided fastperm_mean is used instead of fastperm.
%--------------------------------------------------------------------------
% OUTPUT:
%   - lower_band: Lower confidence band for the data field.
%   - upper_band: Upper confidence band for the data field.
%   - threshold: The bootstrap threshold used to construct the bands.
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------
s_data = size(data);
nsubj = s_data(end);
D = length(s_data) - 1;
data_mean = mean(data, D+1);

if ~exist('nblocks', 'var')
    nblocks = nsubj;
end

if ~exist('sigmahat', 'var') || isempty(sigmahat)
    sigmahat = std(data, 0, D+1);
    demeaned_data = data - data_mean;
    threshold = fastperm( demeaned_data, nblocks, alpha/2, nboot, show_loader);
else
    demeaned_data = data - data_mean;
    threshold = fastperm_mean( demeaned_data, nblocks, alpha/2, nboot, 0, show_loader,...
                                                0, 0, sigmahat);
end

% bootstrap_samples = bootstrap( vec_data( data, mask ), nboot, 1, 1, show_loader );
% threshold = prctile(bootstrap_samples, 100*(1-alpha));
% threshold = prctile(bootstrap_samples, 100*(1-alpha/2));
% Need to change to a two sample test when I have the chance

upper_band = data_mean + threshold*sigmahat/sqrt(nsubj);
lower_band = data_mean - threshold*sigmahat/sqrt(nsubj);

end

