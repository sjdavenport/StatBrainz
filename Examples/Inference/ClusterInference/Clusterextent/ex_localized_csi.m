%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the localized_csi function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Regional p-values for a simple 2D example
dim = [30,30];
tstat = zeros(dim);
tstat(5:9, 5:9) = 4;       % a large cluster
tstat(20:21, 20) = 4;      % a small cluster
region_masks = {zeros(dim), zeros(dim)};
region_masks{1}(1:15, 1:15) = 1;
region_masks{2}(16:30, 16:30) = 1;
% Maximum cluster sizes from (for example) a permutation distribution
vec_of_maxima = [1, 3, 5, 8, 12, 15, 20, 30, 2, 4];
[pvals, max_cluster_within_region] = localized_csi( tstat, region_masks, vec_of_maxima, 8, 3.1, 0 )

%% Simulated data with permutation inference
rng(1)
dim = [40,40]; nsubj = 30; FWHM = 3; CDT = 2.3;
Sig = 0.8*square_signal(dim, 4, {[10,10], [30,30]});
data = fast_conv(randn([dim, nsubj]), FWHM, 2) + Sig;
[threshold, vec_of_maxima] = perm_cluster( data, ones(dim), CDT, 8, 0.05, 100, 0 );
tstat = mvtstat(data);
quarters = cell(1,4);
for I = 1:4
    quarters{I} = zeros(dim);
    quarters{I}((1:20) + 20*(I > 2), (1:20) + 20*mod(I-1,2)) = 1;
end
pvals = localized_csi( tstat, quarters, vec_of_maxima, 8, CDT, 0 )

%% Show the regions with p-values below 0.05
significant = zeros(dim);
for I = find(pvals < 0.05)
    significant = significant + quarters{I};
end
subplot(1,2,1); imagesc(tstat); axis image off; title('t-statistic')
subplot(1,2,2); imagesc(significant); axis image off; title('Significant regions')
