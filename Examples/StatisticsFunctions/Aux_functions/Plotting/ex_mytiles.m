%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the mytiles function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Write some images of the same size to a temporary folder
cmaps = {'parula', 'hot', 'gray', 'jet', 'bone', 'cool'};
filepaths2tiles = cell(1, 6);
for I = 1:6
    rng(I)
    im = uint8(255*ind2rgb(randi(64, 40, 60), feval(cmaps{I}, 64)));
    filepaths2tiles{I} = fullfile(tempdir, ['mytiles_ex', num2str(I), '.png']);
    imwrite(im, filepaths2tiles{I});
end

%% A 2 by 3 layout with 5 pixels of padding
padded_im = mytiles( [2,3], filepaths2tiles, 5 );
size(padded_im)

%% A 3 by 2 layout with no padding
padded_im = mytiles( [3,2], filepaths2tiles, 0 );
size(padded_im)

%% A 1 by 2 layout of the first two images
padded_im = mytiles( [1,2], filepaths2tiles(1:2), 10 );
size(padded_im)
