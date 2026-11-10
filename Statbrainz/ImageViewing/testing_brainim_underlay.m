brain_im = imgload('MNIbrain.nii.gz');
brain_im_2D = squeeze(brain_im(57,:,:));
brain_im_bw = ones([size(brain_im_2D), 3]);
brain_im_bw = brain_im_bw.*brain_im_2D/max(brain_im(:));
imagesc(brain_im_bw)

%%
figure
imagesc(brain_im_2D)
colormap('gray')