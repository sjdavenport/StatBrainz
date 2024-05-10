%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the scopes_lm function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nsubj = 100;
age = randi([40,60], nsubj, 1);
age = age-mean(age);
sex = rand(nsubj, 1) > 0.6;
sex = sex - mean(sex);
X = randn(nsubj,1);
Z = [ones(nsubj,1), sex, age];
design_matrix = [X,Z];
contrast_matrix = [1,0,0,0];
% X_coeff = 2;

FWHM_sig = 5;
dim = [50,50];
X_coeff = fast_conv(randn(dim), FWHM_sig, 2);
data = 5 + randn([dim, nsubj])/5;
for I = 1:nsubj
    data(:,:,I) = data(:,:,I) + 0.2*sex(I) + 0.12*age(I) + X(I)*X_coeff;
end

mask = ones(dim);
data_reshaped = vec_data(data, mask);

%%
[tstat_array, residuals, Cbetahat, betahat, sigmahat ] = contrast_tstats( data_reshaped, design_matrix, contrast_matrix );
tstat_im = unwrap(tstat_array, mask);
Cbetahat_im = unwrap(Cbetahat, mask);
imagesc(tstat_im);

%%
imagesc(tstat_im > threshold)

%%
[ lower_band, upper_band ] = scopes_lm( data_reshaped, design_matrix, contrast_matrix, 1000, 0.05, 1 );
lower_band_im = unwrap(lower_band, mask);
upper_band_im = unwrap(upper_band, mask);

%%
c = 0;
cope_display( upper_band_im > c, lower_band_im > c, Cbetahat_im, c, X_coeff, 1, 0);
fullscreen;

%%
plot(lower_band)
hold on
plot(upper_band)

%%
imagesc(lower_band_im > c)