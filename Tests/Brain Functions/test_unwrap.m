%% test_unwrap
% Tests of the unwrap function.
%--------------------------------------------------------------------------
rng(3)
mask = [1 0 1 1; 0 1 0 1; 1 1 0 0];
nvox = sum(mask(:));

%% One subject: values go to the in-mask voxels, zeros elsewhere
data = (1:nvox)';
out = unwrap(data, mask);
assert(isequal(size(out), size(mask)))
assert(isequal(out(mask > 0), data))
assert(all(out(mask == 0) == 0))

%% Several subjects give an array of size [size(mask), nsubj]
nsubj = 3;
data = randn(nvox, nsubj);
out = unwrap(data, mask);
assert(isequal(size(out), [size(mask), nsubj]))
for I = 1:nsubj
    img = out(:, :, I);
    assert(isequal(img(mask > 0), data(:, I)))
end

%% Inverse of vec_data
assert(isequal(vec_data(out, mask), data))

%% 3D mask
mask3 = rand(3, 4, 5) > 0.5;
data = randn(sum(mask3(:)), 2);
out = unwrap(data, mask3);
assert(isequal(size(out), [3, 4, 5, 2]))
assert(isequal(vec_data(out, mask3), data))

%% Cell array input gives a cell array output
data = {randn(nvox, 1), randn(nvox, 2)};
out = unwrap(data, mask);
assert(iscell(out) && length(out) == 2)
assert(isequal(out{1}, unwrap(data{1}, mask)))
assert(isequal(out{2}, unwrap(data{2}, mask)))
