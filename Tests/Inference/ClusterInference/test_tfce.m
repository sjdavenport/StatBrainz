%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the tfce function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
rng(1)
connectivity_criterion = 8; H = 2; E = 0.5; dim = [50,50];
nsubj = 50; FWHM = 5;
Sig = 0.1*square_signal(dim, 10, {[25,15], [25,36]} );

data = randn([dim, nsubj]) + Sig;
data = fast_conv(data, FWHM, 2);
tstat_orig = mvtstat(data);
tfce_tstat = tfce(tstat_orig, H, E, connectivity_criterion);
subplot(1,2,1); imagesc(tstat_orig); axis off
subplot(1,2,2); imagesc(tfce_tstat); axis off

%%
figure; set(gcf,'Visible','on')
[threshold_tfce, vec_of_maxima_tfce] = perm_tfce(data, ones(dim), H, E, connectivity_criterion);
subplot(1,2,1); viewthresh(tfce_tstat > threshold_tfce, [1,0,0], [1,1,1]); title('TFCE', 'color', 'white');

viewthresh(tfce_tstat > threshold_tfce, [0.5,1,1]); title('TFCE', 'color', 'white');