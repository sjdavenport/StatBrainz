%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the sss_cope_sets function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dim = [100, 100]; D = length(dim);
mu = repmat(linspace(1, 3), dim(2), 1);
nsubj = 60;
FWHM = 3;
mask = ones(dim);
c = 2;

% noise = noisegen( dim, nsubj, FWHM );
lat_data = wfield( dim, nsubj, 'L', 1);
f = convfield(lat_data, FWHM);
noise = f.field;
data = noise + mu;

[lower_set, upper_set] = sss_cope_sets(data, mask, c, 1000);
cope_display(lower_set, upper_set)
