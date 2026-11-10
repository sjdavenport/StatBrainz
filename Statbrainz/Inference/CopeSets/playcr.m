dim = [100, 100]; D = length(dim);
mu = repmat(linspace(1, 3), dim(2), 1);
nsubj = 30; FWHM = 5; c = 2;
lat_data = randn([dim, nsubj]);
noise = fast_conv(lat_data, FWHM, 2)*5;
data = noise + mu;

tstat = mvtstat(data - c);
pvals = tstat2pval(tstat, nsubj-1, 0);
rej_ind = fdrBH(pvals);
imagesc(rej_ind);

% [lower_fdr, upper_fdr] = fdr_crs( data, c );
% cope_display( lower_fdr, upper_fdr, mean(data,3), c ) 

%%
imagesc(mvtstat(data))