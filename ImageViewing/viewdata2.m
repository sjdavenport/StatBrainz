function viewdata2( regions, colors, alphas )
% VIEWDATA2 displays a set of binary region masks as colored overlays on a black background.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  regions  a cell array of 2D binary region masks, all of the same size [r,c]
%  colors   a cell array of 1x3 RGB vectors specifying the color for each region
% Optional
%  alphas   a vector of transparency values for each region. Default is ones(1, length(regions)).
%--------------------------------------------------------------------------
% OUTPUT
% None.
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

if ~exist('alphas', 'var')
    alphas = ones(1, length(regions));
end

% Set the background to be black
dim = size(regions{1});
color = zeros([dim,3]);
imagesc(color)
hold on

for I = 1:length(regions)
    color = zeros([dim,3]);
    color(:,:,1) = colors{I}(1);
    color(:,:,2) = colors{I}(2);
    color(:,:,3) = colors{I}(3);
    im = imagesc(color); hold on;
    set(im,'AlphaData', alphas(1)*regions{I});
end

axis off

end

