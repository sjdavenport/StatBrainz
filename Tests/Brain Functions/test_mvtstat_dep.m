%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the mvtstat_dep function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

noise = normrnd(0, 1, [91,109,91, 20]);
tstat = mvtstat(noise);

%% 2D case
Dim = [100,100];
noise = normrnd(0, 1, [Dim, 20]);
tstat = mvtstat(noise, Dim);

%% 1D case
Dim = 100;
noise = normrnd(0, 1, [Dim, 20]);
tstat = mvtstat(noise);

%% Check at a single voxel
nsubj = 20;
noise = normrnd(0, 1, [91*109*91, nsubj]);
tstat = mvtstat(noise);
vox = 150;
noise_at_vox = noise(vox, :);
muuuu = mean(noise_at_vox)
sigmatilde = std(noise_at_vox)
sqrt(nsubj)*muuuu/sigmatilde
tstat(vox)
