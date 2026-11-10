%% test_vec_data
% Tests of the vec_data function.
%--------------------------------------------------------------------------
rng(4)

%% Known values for a 2D mask
data = reshape(1:24, [2, 3, 4]);
mask = [1 0 1; 0 1 0];
out = vec_data(data, mask);
assert(isequal(size(out), [3, 4]))
assert(isequal(out(:, 1), [1; 4; 5]))
assert(isequal(out(:, 4), [19; 22; 23]))

%% Output size is nvox by nsubj
a = randn(10, 10, 50);
out = vec_data(a, ones(10, 10));
assert(isequal(size(out), [100, 50]))
assert(isequal(out, reshape(a, [100, 50])))

%% 1D data
a = randn(100, 5);
mask = rand(1, 100) > 0.5;
out = vec_data(a, mask);
assert(isequal(out, a(mask, :)))

%% 3D mask: same as logical indexing for each subject
a = randn(4, 5, 6, 3);
mask = rand(4, 5, 6) > 0.4;
out = vec_data(a, mask);
for I = 1:3
    img = a(:, :, :, I);
    assert(isequal(out(:, I), img(mask)))
end
