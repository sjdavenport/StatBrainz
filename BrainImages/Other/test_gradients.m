data = readNPY("/Users/samd/Downloads/principle_gradient_asd.npy");

srfwhite = loadsrf('fs5', 'sphere');

srfdata.lh = data(1:10242);
srfdata.rh = data(10243:end);
srfplot(srfwhite, srfdata, 'all')

%%
xml = xmlread('/Users/samd/Documents/Other/MyCode/StatBrainz/BrainImages/Gifti_files/S1200.L.inflated_MSMAll.32k_fs_LR.surf.gii');

%%
gii = load_gifti('/Users/samd/Documents/Other/MyCode/StatBrainz/BrainImages/Gifti_files/S1200.L.inflated_MSMAll.32k_fs_LR.surf.gii');

%%
gifti2srf('/Users/samd/Documents/Other/MyCode/StatBrainz/BrainImages/Surface/hcp/Sphere.10k.L.surf.gii', '/Users/samd/Documents/Other/MyCode/StatBrainz/BrainImages/Surface/hcp/Sphere.10k.R.surf.gii')

%%
gifti('/Users/samd/Documents/Other/MyCode/StatBrainz/BrainImages/Surface/hcp/Sphere.10k.L.surf.gii')

%%
lh = load('/Users/samd/Documents/Other/MyCode/StatBrainz/BrainImages/Surface/hcp/Sphere.10k.L.surf.mat')
rh = load('/Users/samd/Documents/Other/MyCode/StatBrainz/BrainImages/Surface/hcp/Sphere.10k.R.surf.mat')

%%

srf.lh.faces = lh.faces
srf.lh.vertices = lh.vertices

srf.rh.faces = rh.faces
srf.rh.vertices = rh.vertices

srfplot(srf, srfdata, 'all')

%%
hcp_srf = loadsrf('hcp');

