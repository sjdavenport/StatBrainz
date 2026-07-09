function filled = fill_holes( BW )
% FILL_HOLES fills holes in a 2D binary image without the Image Processing
% Toolbox (a replacement for imfill( BW, 'holes' )).
%--------------------------------------------------------------------------
% A hole is a set of background pixels that cannot be reached by flooding
% inward from the border of the image. Such pixels are set to true; all
% background connected to the border is left as false. Background
% connectivity is 4-connected, matching the default of imfill in 2D.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  BW   a 2D array; non-zero entries are treated as foreground
%--------------------------------------------------------------------------
% OUTPUT
%  filled   the hole-filled logical array, the same size as BW
%--------------------------------------------------------------------------
% EXAMPLES
% BW = zeros(7); BW(2:6,2:6) = 1; BW(4,4) = 0;   % a square with a hole
% fill_holes( BW )
%--------------------------------------------------------------------------
% Copyright (C) - 2026 - Samuel Davenport
%--------------------------------------------------------------------------

BW = BW ~= 0;
[nr, nc] = size( BW );

% reachable(i,j) == true once background pixel (i,j) has been reached by a
% flood fill starting from the border.
reachable = false( nr, nc );

% Seed the flood from every background pixel on the border.
stack = zeros( nr*nc, 1 );
sp = 0;
for j = 1:nc
    for i = [1, nr]
        if ~BW(i,j) && ~reachable(i,j)
            reachable(i,j) = true; sp = sp + 1; stack(sp) = sub2ind([nr nc], i, j);
        end
    end
end
for i = 1:nr
    for j = [1, nc]
        if ~BW(i,j) && ~reachable(i,j)
            reachable(i,j) = true; sp = sp + 1; stack(sp) = sub2ind([nr nc], i, j);
        end
    end
end

% 4-connected flood fill through the background.
while sp > 0
    idx = stack(sp); sp = sp - 1;
    [i, j] = ind2sub( [nr nc], idx );
    nbr = [i-1, j; i+1, j; i, j-1; i, j+1];
    for k = 1:4
        ii = nbr(k,1); jj = nbr(k,2);
        if ii >= 1 && ii <= nr && jj >= 1 && jj <= nc ...
                && ~BW(ii,jj) && ~reachable(ii,jj)
            reachable(ii,jj) = true;
            sp = sp + 1; stack(sp) = sub2ind([nr nc], ii, jj);
        end
    end
end

% Anything that is background but not reachable from the border is a hole.
filled = BW | ~reachable;

end
