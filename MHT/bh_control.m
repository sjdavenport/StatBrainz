nvals = 200000;
normal_rvs = normrnd(0,1,1,nvals);
normal_rvs(1) = normal_rvs(1) + 20;
pvalues = 1 - normcdf(normal_rvs);

[ rej_locs, nrejs ] =  fdrBH(pvalues);

%%
nvals = 100;
normal_rvs = normrnd(0,1,1,nvals);
normal_rvs(1:20) = normal_rvs(1:20) + 2;

pvalues = 1 - normcdf(normal_rvs);
[ sig_locs, nrejections ] = fdrBH(pvalues)

%% Checking FDR control
niters = 10000;

nvals = 100; ntrue = 20;

fdr_est = 0;
for I = 1:niters
    normal_rvs = normrnd(0,1,1,nvals);
    normal_rvs(1:ntrue) = normal_rvs(1:ntrue) + 2;
    pvalues = 1 - normcdf(normal_rvs);

    [ sig_locs, nrejections ] = fdrBH(pvalues);
    
    if nrejections > 0 
        fdr_est = fdr_est + sum( sig_locs(ntrue+1:end) > 0 )/nrejections;
    end
end

fdr_est/niters
% this is about 0.04 when ntrue = 20, it gets worse as the number of true
% hypotheses goes up!!!

%% FDR control under dependence
niters = 10000; FWHM = 10;
nvals = 100; ntrue = 20;

fdr_est = 0;
for I = 1:niters
    normal_rvs = noisegen(nvals, 1, FWHM)';
    normal_rvs(1:ntrue) = normal_rvs(1:ntrue) + 2;
    pvalues = 1 - normcdf(normal_rvs);

    [ sig_locs, nrejections ] = fdrBH(pvalues);
    
    if nrejections > 0 
        fdr_est = fdr_est + sum( sig_locs(ntrue+1:end) > 0 )/nrejections;
    end
end

fdr_est/niters
% this is about 0.036 when ntrue = 20 (less than when there is no dependence!)
% it gets worse as the number of true % hypotheses goes up!!!