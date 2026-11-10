%% test_gen_noise
% Tests of the gen_noise function.
%--------------------------------------------------------------------------

%% Output size with the default nsubj = 1
rng(1)
mask = true(20, 20);
noise = gen_noise(mask, 3);
assert(isequal(size(noise), [20, 20]))

%% Output size with nsubj subjects in 2D and 3D
noise = gen_noise(true(10, 12), 2, 5);
assert(isequal(size(noise), [10, 12, 5]))
noise = gen_noise(true(6, 7, 8), 2, 3);
assert(isequal(size(noise), [6, 7, 8, 3]))

%% Zero outside the mask (default mean_img is zero)
mask = false(20, 20); mask(5:15, 5:15) = true;
noise = gen_noise(mask, 3, 4);
outside = repmat(~mask, [1, 1, 4]);
assert(all(noise(outside) == 0))
assert(all(noise(~outside) ~= 0))

%% Unit variance at the centre (the smoothing is normalised)
rng(2)
noise = gen_noise(true(30, 30), 4, 2000);
v = var(squeeze(noise(15, 15, :)));
assert(abs(v - 1) < 0.15)

%% mean_img and std_img shift and scale the noise
rng(3)
mask = true(30, 30);
mean_img = 5*ones(30, 30); std_img = 2*ones(30, 30);
noise = gen_noise(mask, 4, 2000, mean_img, std_img);
x = squeeze(noise(15, 15, :));
assert(abs(mean(x) - 5) < 0.2)
assert(abs(std(x) - 2) < 0.2)

%% Smoothing gives correlated neighbours
rng(4)
noise = gen_noise(true(30, 30), 6, 2000);
r = corrcoef(squeeze(noise(15, 15, :)), squeeze(noise(15, 16, :)));
assert(r(1, 2) > 0.5)
