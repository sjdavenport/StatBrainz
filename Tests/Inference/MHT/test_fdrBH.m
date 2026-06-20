%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the fdrBH function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nvals = 100; normal_rvs = normrnd(0,1,1,nvals);
normal_rvs(1:20) = normal_rvs(1:20) + 2;
pvalues = 1 - normcdf(normal_rvs);
[ rejection_ind, nrejections, sig_locs ] = fdrBH(pvalues)
