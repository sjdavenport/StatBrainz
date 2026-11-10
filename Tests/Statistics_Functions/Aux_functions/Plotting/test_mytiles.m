%% test_mytiles
% Tests of the mytiles function.
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')

% Six images of size 4 by 5, image I has all values equal to 10*I
filepaths2tiles = cell(1, 6);
for I = 1:6
    filepaths2tiles{I} = fullfile(tempdir, ['test_mytiles', num2str(I), '.png']);
    imwrite(uint8(10*I*ones(4, 5, 3)), filepaths2tiles{I});
end

%% Output size and class for a 2 by 3 layout
padding = 2;
padded_im = mytiles([2, 3], filepaths2tiles, padding);
assert(isa(padded_im, 'uint8'))
assert(isequal(size(padded_im), [2*4 + 3*padding, 3*5 + 4*padding, 3]))

%% Tiles are placed row by row and the padding is zero
for row = 1:2
    for col = 1:3
        xs = padding*row + 4*(row - 1) + (1:4);
        ys = padding*col + 5*(col - 1) + (1:5);
        tile = padded_im(xs, ys, :);
        assert(all(tile(:) == 10*(col + 3*(row - 1))))
    end
end
assert(all(padded_im(1:padding, :, :) == 0, 'all'))
assert(all(padded_im(:, 1:padding, :) == 0, 'all'))

%% A 3 by 2 layout with no padding
padded_im = mytiles([3, 2], filepaths2tiles, 0);
assert(isequal(size(padded_im), [12, 10, 3]))
assert(all(padded_im(1:4, 6:10, :) == 20, 'all'))
assert(all(padded_im(9:12, 1:5, :) == 50, 'all'))
close all

for I = 1:6
    delete(filepaths2tiles{I});
end
