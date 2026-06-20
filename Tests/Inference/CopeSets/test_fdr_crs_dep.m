%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the fdr_crs_dep function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dim = [100, 100]; D = length(dim);
mu = repmat(linspace(1, 3), dim(2), 1);
nsubj = 30;
FWHM = 3;
mask = ones(dim);
c = 2;

lat_data = wfield( dim, nsubj, 'L', 1);
f = convfield(lat_data, FWHM);
noise = f.field;
data = noise + mu;

[lower_fdr, upper_fdr] = fdr_cope_sets( data, c );
