%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the scopes function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FWHM_sig = 5;
dim = [50,50];
nsubj = 100;
Sig = fconv(wfield(dim, 1).field, FWHM_sig, 2);

data = wfield(dim, nsubj).field + Sig;
FWHM_applied = 5;

% smoothed_data = fconv(data, FWHM_applied, 2);
params = ConvFieldParams([FWHM_applied, FWHM_applied], 1, 0);
data_field = Field(data, ones(dim)>0);
smoothed_data = convfield(data_field, params);
mask = smoothed_data.mask;
smoothed_data = smoothed_data.field;
c_vec = 0:0.1:0.2;
[ lower_band, upper_band ] = scopes( smoothed_data, 1000, 0.05, 1 );

smooth_Sig = convfield(Sig, params).field;

%%
figure 
c_vec = 0.05:0.05:0.2;
for I = 1:length(c_vec)
    subplot(2,2,I)
    cope_display( upper_band > c_vec(I), lower_band > c_vec(I), mean(smoothed_data,3), c_vec(I), smooth_Sig, 1, 0);
    title(['SCOPES, c = ', num2str(c_vec(I))])
end
fullscreen

%%
f = @(c) cope_display( upper_band > c, lower_band > c, mean(smoothed_data,3), c, NaN, 1, 0);
sliderGUI(f, 0, 0.2, 'c')