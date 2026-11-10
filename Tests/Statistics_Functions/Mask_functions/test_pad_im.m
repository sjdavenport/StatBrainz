%% test_pad_im
% Tests for pad_im: zero padding (positive) or cropping (negative).
%--------------------------------------------------------------------------

%% 2D padding with the default upper padding
im = magic(4);
out = pad_im( im, [1 2] );
assert( isequal( size(out), [6 8] ) )
assert( isequal( out(2:5, 3:6), im ) )
assert( sum(out(:)) == sum(im(:)) )

%% Different lower and upper padding
out = pad_im( im, [1 0], [2 3] );
assert( isequal( size(out), [7 7] ) && isequal( out(2:5, 1:4), im ) )

%% 3D padding
im = rand(3, 4, 5);
out = pad_im( im, [1 1 2] );
assert( isequal( size(out), [5 6 9] ) && isequal( out(2:4, 2:5, 3:7), im ) )

%% 4D padding
im = rand(2, 3, 2, 2);
out = pad_im( im, [1 1 1 0] );
assert( isequal( size(out), [4 5 4 2] ) && isequal( out(2:3, 2:4, 2:3, :), im ) )

%% 3D cropping undoes the padding
im = rand(3, 4, 5);
assert( isequal( pad_im( pad_im( im, [1 2 1] ), [-1 -2 -1] ), im ) )
im = rand(6, 6, 6);
assert( isequal( pad_im( im, [-1 -2 0], [-2 0 -1] ), im(2:4, 3:6, 1:5) ) )

%% 4D cropping crops only the first 3 dimensions
im = rand(5, 5, 5, 2);
assert( isequal( pad_im( im, [-1 -1 -1] ), im(2:4, 2:4, 2:4, :) ) )

%% 2D cropping
im = magic(5);
assert( isequal( pad_im( im, [-1 -1] ), im(2:4, 2:4) ) )
