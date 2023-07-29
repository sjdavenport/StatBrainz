nvals = 200000;
normal_rvs = normrnd(0,1,1,nvals);
normal_rvs(1) = normal_rvs(1) + 20;
pvalues = 1 - normcdf(normal_rvs);

[ rej_locs, nrejs ] =  fdrBH(pvalues);

%%
nvals = 100;
normal_rvs = normrnd(0,1,1,nvals);
normal_rvs(1:20) = normal_rvs(1:20) + 2;

pvalues = 1 - normcdf(normal_rvs, 0.5);
[ sig_locs, nrejections ] = fdrBH(pvalues)


%%
normal_rvs = normal_rvs(:);
pvalues = 1 - normcdf(normal_rvs);
[ sig_ind, nrejections, sig_locs ] = fdrBH(pvalues, 0.5)

%% Checking FDR control
niters = 10000;

nvals = 100; ntrue = 0;

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
nvals = 100; ntrue = 0;

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

%% t-statistic
niters = 10000; FWHM = 10;
nvals = 100; ntrue = 0;

fdr_est = 0; df = 3;
for I = 1:niters
    t_rvs = wfield(nvals, 1, 'T', 3).field;
    t_rvs(1:ntrue) = t_rvs(1:ntrue) + 2;
    pvalues = 1 - tcdf(t_rvs, df);

    [ sig_locs, nrejections ] = fdrBH(pvalues);
    
    if nrejections > 0 
        fdr_est = fdr_est + sum( sig_locs(ntrue+1:end) > 0 )/nrejections;
    end
end

fdr_est/niters

% Give 0.0474 when ntrue = 0. :)
