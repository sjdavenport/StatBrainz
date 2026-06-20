%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the fdr_crs function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dim = [100, 100]; D = length(dim);
mu = repmat(linspace(1, 3), dim(2), 1);
nsubj = 30; FWHM = 5; c = 2;
lat_data = randn([dim, nsubj]);
noise = fast_conv(lat_data, FWHM, 2)*5;
data = noise + mu;

[lower_fdr, upper_fdr] = fdr_crs( data, c );
cope_display( lower_fdr, upper_fdr, mean(data,3), c ); fullscreen
