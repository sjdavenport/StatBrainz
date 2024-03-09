%% Clustersize Inference in StatBrainz

subjectids = filesindir('C:\Users\12SDa\davenpor\Data\HCP\HCPContrasts\WM\');
data = zeros([91,109,91,80]);
for I = 1:length(subjectids)
    modul(I,10)
    subject_file_loc = ['C:\Users\12SDa\davenpor\Data\HCP\HCPContrasts\WM\',...
                                    subjectids{I}, '\WM\Level2\cope11.nii.gz'];
    data(:,:,:,I) = imgload(subject_file_loc);
end
%% 
% Load in the mask:

figure
MNImask = imgload('MNImask');
imagesc(squeeze(MNImask(:,:,45)))
axis off
%% 
% Calculate the t-statistic:

figure
tstat_full = mvtstat(data);
mask = ~isnan(tstat_full).*MNImask;
tstat_orig = zero2nan(tstat_full.*mask);
viewdata(tstat_orig(:,:,50), mask(:,:,50))
axis image
%% 
% View super-threshold clusters

CDT = 3.1; connectivity_criterion = 26;
slice = 50;
overlay_brain( [0,0,slice], 4, {tstat_orig(:,:,50) > 3.1}, {'red'}, 0.6, 4)
fullscreen
%% 
% 

[number_of_clusters, occurences, sizes, index_locations] = numOfConComps(tstat_orig, CDT, connectivity_criterion);
[ surviving_cluster_im, surviving_clusters, surviving_clusters_vec] = cluster_im( size(mask), index_locations, threshold_cluster );

%% 
% 

threshold_cluster = perm_cluster(data, mask, CDT, connectivity_criterion);