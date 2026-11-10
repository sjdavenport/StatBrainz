%% test_viewthresh
% Tests of the viewthresh function.
%--------------------------------------------------------------------------
rng(1)
set(0, 'DefaultFigureVisible', 'off')
map = rand(6, 7) > 0.5;
m = double(map);

%% Output size
im = viewthresh( map, [1, 0, 0] );
assert(isequal(size(im), [6, 7, 3]))

%% Default background is black
assert(isequal(im, cat(3, m, 0*m, 0*m)))

%% Foreground and background colours
fg = [0.1, 0.5, 0.9]; bg = [0.3, 0.2, 1];
im = viewthresh( map, fg, bg );
for I = 1:3
    assert(isequal(im(:,:,I), fg(I)*m + bg(I)*(1-m)))
end

%% All foreground and all background
assert(isequal(viewthresh( true(3), [0, 1, 0], [1, 1, 1] ), cat(3, zeros(3), ones(3), zeros(3))))
assert(isequal(viewthresh( false(3), [0, 1, 0], [1, 0, 1] ), cat(3, ones(3), zeros(3), ones(3))))
close all
