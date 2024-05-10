function [ lower_band, upper_band ] = scopes_lm( data, design_matrix, contrast_matrix, nboot, alpha, show_loader )
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

if ~exist('nboot', 'var')
    nboot = 5000;
end

if ~exist('alpha', 'var')
    alpha = 0.05;
end

if ~exist('show_loader', 'var')
    show_loader = 1;
end

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------
s_data = size(data);
nsubj = s_data(end);

% demeaned_data = data - data_mean;
% threshold = fastperm( demeaned_data, nsubj, alpha/2, nboot, show_loader); 
do_abs = 1;
[ threshold, ~, cqs] = ... 
      fastlmperm( data, design_matrix, contrast_matrix, 100, do_abs, alpha, 1000, 0, show_loader);

[lower_band, upper_band] = lmthresh2scb(threshold, cqs.Cbetahat, cqs.sigmahat, cqs.scaling_constants);

% lmthresh2scb(threshold, design_matrix, contrast_matrix, cqs.betahat, cqs.sigmahat);
% upper_band = data_mean + threshold*sigma_hat/sqrt(nsubj);
% lower_band = data_mean - threshold*sigma_hat/sqrt(nsubj);

end

