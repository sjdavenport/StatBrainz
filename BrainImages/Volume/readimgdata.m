sb_dir = statbrainz_maindir;
fid1  = fopen([sb_dir, 'BrainImages\Volume\avg152T1_gray.img']);
data = fread(fid1);
data = reshape(data, [91,109,91])/255;
imagesc(data(:,:,45));
colorbar

%%
save('./GMbrain', 'data');
data = data > 0.5;
save('./GMmask', 'data');

%%
mask = GM_intensity > 0.5;
imagesc(mask(:,:,45))

% close(fid1)