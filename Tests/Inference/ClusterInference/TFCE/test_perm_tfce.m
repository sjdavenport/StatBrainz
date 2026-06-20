%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the perm_tfce function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dim = [50,50]; nsubj = 50; FWHM = 0;
Sig = 0.25*peakgen(1, 10, 8, dim);
data = wfield(dim, nsubj).field + Sig;
threshold = perm_tfce(data, ones(dim))
