filename = 'HarvardOxford-cort-maxprob-thr25-1point5_linear_orig.nii.gz';
HOlinearatlas = imgload(filename);

rounded_HOatlas = round(HOlinearatlas);

subplot(2,1,1)
imagesc(HOlinearatlas(:,:,50));
subplot(2,1,2)
imagesc(rounded_HOatlas(:,:,50));


% These atlases were derived using nilearn see
% 'C:\\Users\\12SDa\\davenpor\\davenpor\\Toolboxes\\Other\\Playground\\nilearn'