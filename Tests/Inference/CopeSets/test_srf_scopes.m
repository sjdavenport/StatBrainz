%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srf_scopes function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
FWHM_sig = 5;
dim = [50,50];
nsubj = 100;
Sig = fast_conv(wnoise(dim, 1), FWHM_sig, 2);

data = wnoise(dim, nsubj) + Sig;
FWHM_applied = 5;

mask = ones(dim) > 0;
smoothed_data = fast_conv(data, FWHM_applied, 2);
c_vec = 0:0.1:0.2;
[ lower_band, upper_band ] = scopes( smoothed_data, mask, 1000, 0.05, 1 );

smooth_Sig = fast_conv(Sig, FWHM_applied, 2);

%%
figure
c_vec = 0.05:0.05:0.2;
for I = 1:length(c_vec)
    subplot(2,2,I)
    cope_display( upper_band > c_vec(I), lower_band > c_vec(I), mean(smoothed_data,3), c_vec(I), smooth_Sig, 1, 0, 1.5);
    title(['SCOPES, c = ', num2str(c_vec(I))])
end
fullscreen
