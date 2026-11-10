%% test_brainmove
% Tests of the brainmove function.
% brainmove waits for a key press (waitforbuttonpress), so it is not
% called here. These checks make sure that the functions it needs exist.
%--------------------------------------------------------------------------

%% The functions used by brainmove are on the path
assert(exist('zero2nan') > 0)
assert(exist('nan2zero') > 0)
assert(exist('sbasis') > 0)
assert(exist('pad_vals') > 0)
