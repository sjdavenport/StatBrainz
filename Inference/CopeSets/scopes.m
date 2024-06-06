function [ lower_band, upper_band, threshold ] = scopes( data, nboot, alpha, show_loader, sigmahat )
% SCOPES Computes confidence intervals for a data field using the SCOPES method.
%
%   [lower_band, upper_band] = SCOPES(data, mask, nboot, alpha, show_loader)
%   computes simultaneous confidence bands using the bootstrap.
%--------------------------------------------------------------------------
% ARGUMENTS:
%   - data: Data field of size dim by nsubj.
%   - mask: Binary array (0/1) indicating the region of interest.
%   - nboot: Number of bootstrap samples.
%   - alpha: Significance level for confidence intervals.
%   - show_loader: Flag to display progress loader during computation.
%--------------------------------------------------------------------------
% OUTPUT:
%   - lower_band: Lower confidence band for the data field.
%   - upper_band: Upper confidence band for the data field.
%--------------------------------------------------------------------------
% EXAMPLES
% %%
% FWHM_sig = 5;
% dim = [50,50];
% nsubj = 100;
% Sig = fconv(wfield(dim, 1).field, FWHM_sig, 2);
% 
% data = wfield(dim, nsubj).field + Sig;
% FWHM_applied = 5;
% 
% % smoothed_data = fconv(data, FWHM_applied, 2);
% params = ConvFieldParams([FWHM_applied, FWHM_applied], 3, 0);
% data_field = Field(data, ones(dim)>0);
% smoothed_data = convfield(data_field, params);
% mask = smoothed_data.mask;
% smoothed_data = smoothed_data.field;
% c_vec = 0:0.1:0.2;
% [ lower_band, upper_band ] = scopes( smoothed_data, mask, 1000, 0.05, 1 );
% 
% smooth_Sig = convfield(Sig, params).field;
% 
% %%
% figure 
% c_vec = 0.05:0.05:0.2;
% for I = 1:length(c_vec)
%     subplot(2,2,I)
%     cope_display( upper_band > c_vec(I), lower_band > c_vec(I), mean(smoothed_data,3), c_vec(I), smooth_Sig, 1, 0, 1.5);
%     title(['SCOPES, c = ', num2str(c_vec(I))])
% end
% fullscreen
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------
s_data = size(data);
nsubj = s_data(end);
D = length(s_data) - 1;
data_mean = mean(data, D+1);

if ~exist('sigmahat', 'var') || isempty(sigmahat)
    sigmahat = std(data, 0, D+1);
    demeaned_data = data - data_mean;
    threshold = fastperm( demeaned_data, nsubj, alpha/2, nboot, show_loader);
else
    demeaned_data = data - data_mean;
    threshold = fastperm_mean( demeaned_data, nsubj, alpha/2, nboot, 0, show_loader,...
                                                0, 0, sigmahat);
end

% bootstrap_samples = bootstrap( vec_data( data, mask ), nboot, 1, 1, show_loader );
% threshold = prctile(bootstrap_samples, 100*(1-alpha));
% threshold = prctile(bootstrap_samples, 100*(1-alpha/2));
% Need to change to a two sample test when I have the chance

upper_band = data_mean + threshold*sigmahat/sqrt(nsubj);
lower_band = data_mean - threshold*sigmahat/sqrt(nsubj);

end

