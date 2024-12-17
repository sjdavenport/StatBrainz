function [ padded_im ] = mytiles( layout, filepaths2tiles, padding )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
tiles = cell(1, prod(layout));
for I = 1:length(filepaths2tiles)
    tiles{I} = imread(filepaths2tiles{I});
end

tilesize = size(tiles{1});

layout = fliplr(layout);

% if isequal(layout, [2,3])
padded_im = zeros(layout(2)*tilesize(1) + (layout(2)+1)*padding, layout(1)*tilesize(2) + (layout(1)+1)*padding, 3);
for I = 1:layout(2)
    for J = 1:layout(1)
        xstart = (padding*I) + tilesize(1)*(I-1) + 1;
        xend = (padding*I) + tilesize(1)*I;
        ystart = (padding*J) + tilesize(2)*(J-1) + 1;
        yend =  (padding*J) + tilesize(2)*J;
        padded_im(xstart:xend, ystart:yend, :) = tiles{J+layout(1)*(I-1)};
    end
end
% end
padded_im = uint8(padded_im);
imagesc(padded_im)
axis off image
fullscreen

end

