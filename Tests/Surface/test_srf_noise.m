%% test_srf_noise
% Tests of the srf_noise function
%--------------------------------------------------------------------------
srf = loadsrf('fs3', 'white');
nv = srf.lh.nvertices;

%% Defaults: unsmoothed white noise, one subject, both hemispheres
rng(1)
data = srf_noise(srf);
rng(1)
lh = randn(nv, 1);
rh = randn(nv, 1);
assert(isfield(data, 'lh') && isfield(data, 'rh'))
assert(isequal(data.lh, lh))
assert(isequal(data.rh, rh))

%% Number of subjects
data = srf_noise(srf, 0, 4);
assert(isequal(size(data.lh), [nv, 4]))
assert(isequal(size(data.rh), [nv, 4]))

%% A single hemisphere gives a matrix
data = srf_noise(srf.lh, 0, 3);
assert(isnumeric(data))
assert(isequal(size(data), [nv, 3]))

%% Smoothed noise is smooth_surface applied to white noise
FWHM = 10;
rng(2)
data = srf_noise(srf.lh, FWHM, 2);
rng(2)
expected = smooth_surface(srf.lh, randn(nv, 2), FWHM);
assert(max(abs(data(:) - expected(:))) < 1e-12)
assert(all(var(data) < 1))

%% A mask sets the noise outside the mask to 0
mask = double(srf.lh.vertices(:,3) > 0);
rng(3)
data = srf_noise(srf.lh, 0, 2, 'ones', mask);
rng(3)
expected = randn(nv, 2).*mask;
assert(isequal(data, expected))
assert(all(all(data(mask == 0, :) == 0)))

%% Smoothed noise with a double mask is normalised by the smoothed mask
mask = ones(nv, 1);
rng(4)
data = srf_noise(srf.lh, FWHM, 1, 'ones', mask);
rng(4)
expected = smooth_surface(srf.lh, randn(nv, 1), FWHM);
assert(max(abs(data - expected)) < 1e-10)

%% Smoothed noise with a logical mask (as returned by loadmask)
clear maskb
maskb.lh = srf.lh.vertices(:,3) > 0;
maskb.rh = srf.rh.vertices(:,3) > 0;
data = srf_noise(srf, FWHM, 1, 'ones', maskb);
assert(isequal(size(data.lh), [nv, 1]))
assert(all(data.lh(~maskb.lh) == 0))

disp('test_srf_noise: all tests passed')
