%% test_asinh_data_trans
% Tests of the asinh_data_trans function.
%--------------------------------------------------------------------------
rng(1)

%% Default param is 1: asinh of the data divided by its std
data = randn(50, 1)*3 + 1;
out = asinh_data_trans(data);
assert(isequal(size(out), size(data)))
assert(max(abs(out - asinh(data/std(data)))) < 1e-12)
assert(max(abs(out - asinh_data_trans(data, 1))) < 1e-12)

%% Given param
out = asinh_data_trans(data, 2);
assert(max(abs(out - asinh(2*data/std(data))/2)) < 1e-12)

%% Invariant to a positive scaling of the data
assert(max(abs(asinh_data_trans(5*data, 2) - asinh_data_trans(data, 2))) < 1e-12)

%% Matrix data: each column is divided by its own std
data = randn(30, 4).*[1, 2, 3, 4];
out = asinh_data_trans(data);
assert(isequal(size(out), [30, 4]))
assert(max(abs(out - asinh(data./std(data))), [], 'all') < 1e-12)
