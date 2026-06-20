%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the fdrthresh function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
nvals = 100; normal_rvs = normrnd(0,1,1,nvals);
normal_rvs(1:20) = normal_rvs(1:20) + 2;
pvals = 1 - normcdf(normal_rvs);
df = nvals - 1;
pval_rejection_ind = fdrBH(pvals);
thresh = fdrthresh( pvals, pval_rejection_ind, df )
