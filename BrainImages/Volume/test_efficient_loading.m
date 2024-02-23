tic
cope11 = spm_read_vols(spm_vol('C:\Users\12SDa\davenpor\Data\HCP\HCPContrasts\WM\100307\WM\Level2\cope11.nii.gz'));
toc
tic
load('cope11vec.mat')
toc
%%

MNImask = imgload('MNImask');

cope11vec = cope11(MNImask > 0);

save('./cope11', 'cope11')
save('./cope11vec', 'cope11vec')

%%
greaterthanmask = fm < 0;

save('./gtm', 'greaterthanmask')