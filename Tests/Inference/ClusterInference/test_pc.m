%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the XXX function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rng(3,"twister")

breakupnoise = 0; %0,1
repval = 2; %1-7
scale = 1; %0.5, 1, 2, 3
snr = 0.5; % 0.25, 0.5, 0.75
FWHM = 3; % 1,2,3,4,5

connectivity_criterion = 8; H = 2; E = 0.5;
dim = floor([50,50]*scale); nsubj = 30; 
Sig = zeros(dim);
Sig((floor(11*scale):floor(40*scale)), floor(6*scale):floor(45*scale)) = 0.6;
Sig = repmat(Sig, repval, repval);
bigdim = size(Sig);
% FWHM = 3;
noise = fconv(wfield(bigdim, nsubj).field, FWHM, 2);
noise_std = std(noise(:));
noise = noise/noise_std;
if breakupnoise == 1
    noise2 = fconv(wfield(bigdim, nsubj).field, 10, 2);
    noise2_std = std(noise2(:));
    noise2 = noise2/noise2_std;
    dilated_mask = dilate_mask(Sig > 0,1);
    for I = 1:nsubj
        noiseim = noise(:,:,I);
        noise2im = noise2(:,:,I);
        noiseim((1 - dilated_mask>0)) = noise2im((1 - dilated_mask>0));
        noise(:,:, I) = noiseim;
    end
end
Sig = zeros(bigdim);
data = noise + Sig;
tstat_orig = mvtstat(data);

CDT = 3.1;
[threshold_cluster, vec_of_max_cluster_sizes] = perm_cluster(data, ones(bigdim), CDT, connectivity_criterion);

[~, ~, ~, index_locations] = numOfConComps(tstat_orig, CDT, connectivity_criterion);
[surviving_cluster_im, suviving_clusters] = cluster_im( bigdim, index_locations, threshold_cluster );

imagesc(surviving_cluster_im)
% axis square
fullscreen