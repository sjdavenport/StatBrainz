%% test_asinh_trans
% Tests of the asinh_trans function.
%--------------------------------------------------------------------------

%% Known values
assert(abs(asinh_trans(sinh(1), 1) - 1) < 1e-12)
assert(abs(asinh_trans(sinh(3)/3, 3) - 1) < 1e-12)
assert(asinh_trans(0, 2) == 0)

%% Agrees with asinh(data*param)/param and keeps the size
rng(1)
data = randn([5,6,7]);
out = asinh_trans(data, 2.5);
assert(isequal(size(out), size(data)))
assert(max(abs(out(:) - asinh(2.5*data(:))/2.5)) < 1e-12)

%% Odd function
assert(max(abs(asinh_trans(-data, 2) + asinh_trans(data, 2)), [], 'all') < 1e-12)

%% Close to the identity for a small param
assert(max(abs(asinh_trans(data, 1e-6) - data), [], 'all') < 1e-6)

%% Error if param is missing
errored = 0;
try
    asinh_trans(data);
catch
    errored = 1;
end
assert(errored == 1)
