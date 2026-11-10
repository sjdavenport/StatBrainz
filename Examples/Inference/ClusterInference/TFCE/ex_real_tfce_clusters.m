%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the real_tfce_clusters function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clusters with a large enough TFCE score
dim = [20,20];
tstat = zeros(dim);
tstat(3:6, 3:6) = 3;       % a strong cluster
tstat(14:15, 14) = 1.5;    % a weak cluster
tfce_threshold = 10;
[true_tfce_cluster_im, true_tfce_clusters] = real_tfce_clusters( tstat, ones(dim), tfce_threshold );
imagesc(true_tfce_cluster_im); axis image off

%% Cluster p-values from a permutation distribution of TFCE maxima
vec_of_maxima = [2, 5, 8, 12, 20, 40, 60, 3, 4, 6];
[~, ~, cluster_pvals] = real_tfce_clusters( tstat, ones(dim), tfce_threshold, ...
                                            2, 0.5, 8, 0.1, 0, vec_of_maxima )

%% Simulated data with permutation inference
rng(1)
dim = [30,30]; nsubj = 30; FWHM = 3;
Sig = 0.8*square_signal(dim, 4, {[10,10], [22,22]});
data = fast_conv(randn([dim, nsubj]), FWHM, 2) + Sig;
[tfce_threshold, vec_of_maxima] = perm_tfce( data, ones(dim), 2, 0.5, 8, 0.1, 0, 0.05, 100, 0 );
tstat = mvtstat(data);
[true_tfce_cluster_im, ~, cluster_pvals] = real_tfce_clusters( tstat, ones(dim), ...
                               tfce_threshold, 2, 0.5, 8, 0.1, 0, vec_of_maxima );
subplot(1,2,1); imagesc(tstat); axis image off; title('t-statistic')
subplot(1,2,2); imagesc(true_tfce_cluster_im); axis image off; title('TFCE clusters')
