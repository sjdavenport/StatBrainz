%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the cope_display function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dim = [100,100]; D = length(dim); nsubj = 25; FWHM = 4; c = 1;
mu = peakgen(2, 30, 10, dim); mask = ones(dim);
noise = fast_conv(randn([dim,nsubj]), FWHM, 2);
data = noise + mu; data_mean = mean(data,3);
% Plot FDR cope sets
[lower_fdr, upper_fdr] = fdr_crs( data, c );
cope_display( lower_fdr, upper_fdr, data_mean, c )

%% Plot SSS cope sets
[lower_sss, upper_sss, ~] = sss_cope_sets(data, mask, c);
cope_display( lower_sss, upper_sss, data_mean, c )

%% Plot SSS cope sets with a grey background outside the lower set
cope_display( lower_sss, upper_sss, data_mean, c, NaN, 1 )

% NB: showing the true boundary (truth input) or the contours
% (docontours = 1) needs plot_contour, which is not in the package.
