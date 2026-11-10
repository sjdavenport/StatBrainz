%% test_upsample3_nn
% Tests of the upsample3_nn function.
%--------------------------------------------------------------------------
rng(1)

%% Integer scale factor repeats each voxel
vol = reshape(1:8, [2,2,2]);
out = upsample3_nn( vol, 2 );
assert(isequal(size(out), [4, 4, 4]))
assert(isequal(out(:,:,1), [1 1 3 3; 1 1 3 3; 2 2 4 4; 2 2 4 4]))
assert(isequal(out(:,:,2), out(:,:,1)))
assert(isequal(out(:,:,3), out(:,:,1) + 4))

%% Random array with scale 3: each voxel becomes a 3x3x3 block
vol = rand(3, 4, 2);
out = upsample3_nn( vol, 3 );
assert(isequal(size(out), [9, 12, 6]))
for a = 1:3
    for b = 1:4
        for c = 1:2
            block = out(3*a-2:3*a, 3*b-2:3*b, 3*c-2:3*c);
            assert(all(block(:) == vol(a, b, c)))
        end
    end
end

%% Per-dimension scale factors
vol = rand(4, 6, 8);
out = upsample3_nn( vol, [2, 1, 0.5] );
assert(isequal(size(out), [8, 6, 4]))
sub = vol(:, :, 2:2:8);
assert(isequal(out(1:2:8, :, :), sub))
assert(isequal(out(2:2:8, :, :), sub))

%% Output size is round( scale .* size )
out = upsample3_nn( rand(5, 5, 5), 1.5 );
assert(isequal(size(out), round(1.5*[5, 5, 5])))

%% Scale 1 returns the input
vol = rand(3, 3, 3);
assert(isequal(upsample3_nn( vol, 1 ), vol))

%% Logical masks stay logical with no new values
mask = rand(4, 5, 3) > 0.5;
out = upsample3_nn( mask, 2 );
assert(islogical(out))
assert(nnz(out) == 8*nnz(mask))
