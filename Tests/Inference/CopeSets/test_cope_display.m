%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the cope_display function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dim = [100,100]; D = length(dim); nsubj = 25; FWHM = 4; c = 1;
mu = peakgen(2, 30, 10, dim); mask = ones(dim);
noise = fast_conv(randn([dim,nsubj]), FWHM, 2);
data = noise + mu; data_mean = mean(data,3);
% Plot FDR cope sets
[lower_fdr, upper_fdr] = fdr_cope_sets( data, c );
cope_display( lower_fdr, upper_fdr, data_mean, c, mu )

%% Plot SSS cope sets (with contours)
[lower_sss, upper_sss, ~] = sss_cope_sets(data, mask, c);
cope_display( lower_sss, upper_sss, data_mean, c, mu, 0, 1 )
