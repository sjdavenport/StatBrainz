%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the mvtstat function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
mvtstat(normrnd(0,1,1,100))

%%
noise = normrnd(0, 1, [91,109,91, 20]);
tstat = mvtstat(noise);

%%
Dim = [100,100];
noise = normrnd(0, 1, [Dim, 20]);
tstat = mvtstat(noise, Dim);

%%
Dim = 100;
noise = normrnd(0, 1, [Dim, 20]);
tstat = mvtstat(noise);

%%
nsubj = 20;
noise = normrnd(0, 1, [91*109*91, nsubj]);
tstat = mvtstat(noise);
vox = 150;
noise_at_vox = noise(vox, :);
muuuu = mean(noise_at_vox)
sigmatilde = std(noise_at_vox)
sqrt(nsubj)*muuuu/sigmatilde
tstat(vox)

%%
% For comparison to python code:
data = reshape(1:12,4,3)
[tstat, xbar, std_dev] = mvtstat(data)
