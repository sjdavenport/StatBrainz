%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the perm_cluster function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% prepare workspace
clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %% 1D Examples
%% Simple 1D example


%% %% 2D Examples
%% Simple 2D example - cluster size vs tfce
connectivity_criterion = 8; H = 2; E = 0.5;
dim = [50,50]; nsubj = 50; 
% Sig = 0.5*peakgen(1, 10, 8, dim);
% Sig = zeros(dim); Sig(25:26,25) = 3;
% Sig = 0.35*square_signal(dim, 4, {[25,20], [25,30]} );
Sig = 0.35*square_signal(dim, 5, {[25,14], [25,36]} );
data = randn([dim, nsubj]) + Sig;
% FWHM = 0; 
FWHM = 5;
data = fast_conv(data, FWHM, 2);
CDT = 2.3;
threshold_cluster = perm_cluster(data, ones(dim), CDT, connectivity_criterion);

tstat_orig = mvtstat(data);
[number_of_clusters, occurences, sizes, index_locations] = numOfConComps(tstat_orig, CDT, connectivity_criterion);
surviving_cluster_im = cluster_im( dim, index_locations, threshold_cluster );

%%
subplot(1,2,1)
imagesc(tstat_orig)
title('Original t-stat')
axis off
subplot(1,2,2)
viewthresh(surviving_cluster_im, [1,0.5,0.5])
axis off
title('Cluster extext inference: CDT = 2.3')
fullscreen
BigFont(35)

%% Simple 2D example - cluster size vs copesets
connectivity_criterion = 8; H = 2; E = 0.5;
dim = [50,50]; nsubj = 50; FWHM = 3;
Sig = 0.5*peakgen(1, 10, 8, dim);
% Sig = zeros(dim); Sig(25:26,25) = 3;
% Sig = 0.5*square_signal(dim, 4, {[25,20], [25,30]} );
data = wfield(dim, nsubj).field + Sig;
data = fconv(data, FWHM, 2);

% Run clustersize inference
CDT = 2.3;
threshold_cluster = perm_cluster(data, ones(dim), CDT, connectivity_criterion);

tstat_orig = mvtstat(data);
[number_of_clusters, occurences, sizes, index_locations] = numOfConComps(tstat_orig, CDT, connectivity_criterion);
surviving_cluster_im = cluster_im( dim, index_locations, threshold_cluster );

% Run SSS cope set inference
nboot = 1000;
c = 0.25;
[lower_set, upper_set, std_multipler] = sss_cope_sets(data, ones(dim), c, nboot);

%%
subplot(1,3,1)
surf(tstat_orig)
title('Original t-stat')
axis square
view([-3, 15.58])
subplot(1,3,2)
imagesc(surviving_cluster_im)
title('Cluster extext inference: CDT = 2.3')
axis square
subplot(1,3,3)
cope_display( lower_set, upper_set, mean(data,3), c);
title('Cope set image')
% axis square
fullscreen
% export_fig('C:\Users\12SDa\global\TomsMiniProject\Latex\MyPapers\TFCE_vs_ClusterExtent\round_sig.png')

%% Comparing cluster size inference and scopes
[ lower_band, upper_band ] = scopes( data, 1000, 0.05 );
c_vec = 0:0.25:0.5;
subplot(1,length(c_vec)+1,1)
imagesc(surviving_cluster_im)
axis square
title('Cluster size inference')
for I = 1:length(c_vec)
    subplot(1, length(c_vec)+1,I+1)
    cope_display( upper_band > c_vec(I), lower_band > c_vec(I), mean(data,3), c_vec(I));
    title(['SCOPES, c = ', num2str(c_vec(I))])
end
%% SCOPES
[ lower_band, upper_band ] = scopes( data, 1000, 0.05 );
subplot(2,1,1)
cope_display( upper_band > c, lower_band > c, mean(data,3), c);
subplot(2,1,2)
cope_display( lower_set, upper_set, mean(data,3), c);

%%
imagesc(upper_band)
%% Nearby square signals
dim = [50,50]; nsubj = 50; FWHM = 0;
Sig = 0.25*peakgen(1, 10, 8, dim);
Sig = 0.5*square_signal(dim, 4, {[25,20], [25,30]} );
data = wfield(dim, nsubj);
data.field = data.field + Sig;
tstat = convfield_t(data, FWHM);
tstat_tfce = tfce(tstat.field,2,0.5,8,0.05);

subplot(1,2,1)
surf(tstat.field)
title('Original tstat')
view([-14,15])
subplot(1,2,2)
surf(tstat_tfce)
title('TFCE')
view([-14,15])
fullscreen

%%
CDT = 1;
threshold_cluster = perm_cluster(data, ones(dim), CDT, connectivity_criterion);

[number_of_clusters, occurences, sizes, index_locations] = numOfConComps(tstat_orig, CDT, connectivity_criterion);
surviving_cluster_im = cluster_im( dim, index_locations, threshold_cluster );


%% %% 3D Examples
%% Simple 3D example

%% Real data example
subjectids = filesindir('C:\Users\12SDa\davenpor\Data\HCP\HCPContrasts\WM\');

WM_imgs = zeros([91,109,91,80]);
for I = 1:length(subjectids)
    modul(I,10)
    subject_file_loc = ['C:\Users\12SDa\davenpor\Data\HCP\HCPContrasts\WM\',...
                                    subjectids{I}, '\WM\Level2\cope11.nii.gz'];
    WM_imgs(:,:,:,I) = imgload(subject_file_loc);
end

%%
slice = 35;
WMdata = squeeze(WM_imgs(:,:,slice,:));
MNImask = imgload('MNImask');
mask = MNImask(:,:,slice);
connectivity_criterion = 8;
dim = size(MNImask);

% Run clustersize inference
CDT = 2.3;
% threshold_cluster = perm_cluster(WMdata,mask, CDT, connectivity_criterion);

%%
nsubj_vec = 20:20:80;
threshold_cluster_vec = zeros(1, length(nsubj_vec));
threshold_cluster_vec(end) = 998.5;
for I = 1:(length(nsubj_vec)-1)
    threshold_cluster_vec(I) = perm_cluster(WM_imgs(:,:,:,1:nsubj_vec(I)),MNImask, CDT);
end

%%
c = 5;
nboot = 1000;
WMlower_set = cell(1,4);
WMupper_set = cell(1,4);
for I = 1:4
    I
    [WMlower_set{I}, WMupper_set{I}] = sss_cope_sets(WM_imgs(:,:,:,1:nsubj_vec(I)), MNImask, c, nboot);
end

%%
for index = 1:4
    index
    nsubj = nsubj_vec(index);
    
    WMtstat_orig = mvtstat(WM_imgs(:,:,:,1:nsubj));
    [number_of_clusters, occurences, sizes, index_locations] = numOfConComps(WMtstat_orig, CDT, 26);
    WMsurviving_cluster_im = cluster_im( dim, index_locations, threshold_cluster_vec(I) );
    
    slice = 62;
    ax1 = subplot(1,3,1);
    % imagesc(tstat_orig.*mask)
    viewdata(WMtstat_orig(:,:,slice), MNImask(:,:,slice), {NaN}, [], 4)
    title('Original t-stat')
    axis image off
    ax2 = subplot(1,3,2);
    overlay_brain([0, 0, slice], 10, {WMsurviving_cluster_im(:,:,slice)}, 'red', 0.75, 4)
    title('Cluster extext inference: CDT = 2.3')
    subplot(1,3,3)
    WMyellow_set = mean(WM_imgs(:,:,:,1:nsubj),4)>c;
    overlay_brain([0, 0, slice], 10, {WMlower_set{index}(:,:,slice)-WMyellow_set(:,:,slice),WMyellow_set(:,:,slice)-WMupper_set{index}(:,:,slice),WMupper_set{index}(:,:,slice)}, ...
        {'blue', 'yellow', 'red'}, 1, 4)
    % cope_display( lower_set, upper_set, mean(data,3), c);
    title('Cope set image')
    % axis square
    fullscreen
    colormap(ax1, 'jet')
    export_fig(['C:\Users\12SDa\global\TomsMiniProject\Latex\MyPapers\SCOPEs\nsubj_', num2str(nsubj), '.pdf'])
%     export_fig(['C:\Users\12SDa\global\TomsMiniProject\Latex\MyPapers\SCOPEs\nsubj_', num2str(nsubj), '.pdf'])
    
end

%% Nearby square signals
dim = [100,100]/2; nsubj = 100;
Mag = [0.5, 0.5, 1, 1];
Rad = [ 10, 20, 10, 20]/5;
Sig = 0.25*peakgen(Mag, Rad, 4, dim, {[25, 75]/2, [25, 25]/2, [75,75]/2, [75, 25]/2});
surf(Sig)
data = wfield(dim, nsubj).field + Sig;
FWHM = 4;
data = fconv(data, FWHM, 2);

% Run clustersize inference
CDT = 2.3;
threshold_cluster = perm_cluster(data, ones(dim), CDT, connectivity_criterion);

tstat_orig = mvtstat(data);
[number_of_clusters, occurences, sizes, index_locations] = numOfConComps(tstat_orig, CDT, connectivity_criterion);
surviving_cluster_im = cluster_im( dim, index_locations, threshold_cluster );

% Run SSS cope set inference
nboot = 1000;
c = 0.1;
[lower_set, upper_set, std_multipler] = sss_cope_sets(data, ones(dim), c, nboot);

%%
subplot(1,3,1)
imagesc(tstat_orig)
title('Original t-stat')
axis square
% view([-3, 15.58])
subplot(1,3,2)
imagesc(surviving_cluster_im)
title('Cluster extext inference: CDT = 2.3')
axis square
subplot(1,3,3)
cope_display( lower_set, upper_set, mean(data,3), c);
title('Cope set image')
axis square
fullscreen

%%
c = 10;
nboot = 1000;
[WMlower_set, WMupper_set] = sss_cope_sets(squeeze(WM_imgs(:,:,slice,:)), MNImask(:,:,slice), c, nboot);
    
title('Cope set image')
% axis square
fullscreen
%     colormap(ax1, 'jet')
WMyellow_set = mean(squeeze(WM_imgs(:,:,slice,1:nsubj)),3)>c;
overlay_brain([0, 0, slice], 10, {WMlower_set-WMyellow_set,WMyellow_set-WMupper_set,WMupper_set}, ...
    {'blue', 'yellow', 'red'}, 1, 4)
saveim('copeset example')