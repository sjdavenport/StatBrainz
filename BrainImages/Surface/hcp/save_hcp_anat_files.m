filename = '/Users/sdavenport/Documents/Code/MATLAB/MyPackages/StatBrainz/BrainImages/Surface/hcp/RSN-networks.32k_fs_LR.dlabel.nii';

%anat = niftiread(filename);

wb_path = '/Users/sdavenport/Documents/Software/workbench/macosxub_apps/wb_command.app/Contents/MacOS';
current_path = getenv('PATH');
new_path = [wb_path ':' current_path];
setenv('PATH', new_path);

% Now try your cifti_read command
anat = cifti_read(filename);

%%
rsout = anat.cdata;
clear rsn_networks
for I = 1:4
    rsn_networks(I).lh = rsout(1:32492,I);
    rsn_networks(I).rh = rsout(32493:end,I);
end

save('./RSN-networks_32k.mat', 'rsn_networks')

%%
srf = loadsrf('hcp');

srfplot(srf, rsn_networks(1), 'all')

surfscreen

%%
filename = '/Users/sdavenport/Documents/Code/MATLAB/MyPackages/StatBrainz/BrainImages/Surface/hcp/SensorimotorAssociation_Axis.dscalar.nii';
anat = cifti_read(filename);

saa_data = anat.cdata;

data.lh = zeros(32492, 1);
data.rh = zeros(32492, 1);
data.lh(hcp_mask.lh) = saa_data(1:sum(hcp_mask.lh));
data.rh(hcp_mask.rh) = saa_data((sum(hcp_mask.lh)+1):end);

srfplot(srf, data, 'all')

surfscreen

save('./SensorimotorAssociation_Axis_32k.mat', 'data')

%%
anat = gifti('Desikan.32k.L.label.gii');
clear data
data.lh = anat.cdata;
anat = gifti('Desikan.32k.R.label.gii');
data.rh = anat.cdata;

srfplot(srf, data, 'all')
surfscreen
save('./Desikan_atlas.mat', 'data')

