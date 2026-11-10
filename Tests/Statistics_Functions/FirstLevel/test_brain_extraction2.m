%% test_brain_extraction2
% Tests of the brain_extraction2 function.
%--------------------------------------------------------------------------
% brain_extraction2 is not finished (syntax error at line 22 and undefined
% variables), so these tests fail until it is completed.

%% Returns a binary mask the same size as the image
rng(1)
im = 10*rand(20, 20, 20);
im(5:15, 5:15, 5:15) = 100 + 10*rand(11, 11, 11);
mask = brain_extraction2(im);
assert(isequal(size(mask), size(im)))
assert(all(mask(:) == 0 | mask(:) == 1))

%% Separates the two intensity levels
inner = false(20, 20, 20); inner(5:15, 5:15, 5:15) = true;
assert(isequal(logical(mask), inner))
