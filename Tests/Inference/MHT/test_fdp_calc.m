% Tests for fdp_calc

%% Known FDP: 3 rejections, 1 of them false
rejections = [1, 1, 0, 0; 1, 0, 0, 0];
signal     = [1, 0, 0, 0; 1, 0, 0, 1];
fdp = fdp_calc(rejections, signal);
assert(abs(fdp - 1/3) < 1e-12)

%% No rejections gives 0
assert(fdp_calc(zeros(3, 3), ones(3, 3)) == 0)

%% All rejections correct gives 0 and all false gives 1
signal = logical([1, 0; 0, 1]);
assert(fdp_calc(signal, signal) == 0)
assert(fdp_calc(~signal, signal) == 1)

%% Logical and 3D inputs
rng(3)
signal = rand(4, 4, 4) > 0.5;
rejections = rand(4, 4, 4) > 0.5;
fdp = fdp_calc(rejections, signal);
expected = sum(rejections(:) & ~signal(:))/sum(rejections(:));
assert(abs(fdp - expected) < 1e-12)

%% Error if the masks have different sizes
try
    fdp_calc(ones(2, 4), ones(2, 3));
    errored = 0;
catch e
    errored = contains(e.message, 'Mask size mismatch');
end
assert(errored == 1)
