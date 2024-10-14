im = imgload('/Users/sdavenport/Documents/Code/Python/Other_Packages/nilearn/results/plot_compare_decomposition/canica_resting_state.nii.gz');

path2file = '/Users/sdavenport/nilearn_data/development_fmri/development_fmri/sub-pixar001_task-pixar_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz';
im = imgload(path2file);

%%
im_std = std(im,0,4);

mask = imagesc(im_std(:,:,30)>0.35);

%%
a = randn(size(im));
smooth_a = fast_conv(a, 5, 3)

%%
Zfica = fastICA(im,3);
