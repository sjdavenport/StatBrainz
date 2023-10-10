function [ lower_band, upper_band ] = scopes( data, mask, nboot, alpha, show_loader )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% data: a dim by nsubj 
% mask: a 0/1 array of size dim
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
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
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------
s_data = size(data);
nsubj = s_data(end);
D = length(s_data) - 1;
data_mean = mean(data, D+1);
sigma_hat = std(data, 0, D+1);

% demeaned_data = data - data_mean;
% threshold = fastperm( demeaned_data, nsubj, alpha/2, nboot, show_loader); 
bootstrap_samples = bootstrap( vec_data( data, mask ), nboot, 1, 1, show_loader );
threshold = prctile(bootstrap_samples, 100*(1-alpha));
% threshold = prctile(bootstrap_samples, 100*(1-alpha/2));
% Need to change to a two sample test when I have the chance

upper_band = data_mean + threshold*sigma_hat/sqrt(nsubj);
lower_band = data_mean - threshold*sigma_hat/sqrt(nsubj);

end

