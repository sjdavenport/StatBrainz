function CC = conncomp_bw( BW, connectivity )
% CONNCOMP_BW finds connected components in a 2D or 3D binary array without
% the Image Processing Toolbox (a drop-in replacement for bwconncomp).
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  BW            a 2D or 3D array; non-zero entries are treated as foreground
% Optional
%  connectivity  the neighbourhood connectivity. In 2D one of 4 or 8
%                (default 8); in 3D one of 6, 18 or 26 (default 26).
%--------------------------------------------------------------------------
% OUTPUT
%  CC   a struct mirroring the fields of bwconncomp's output that are used
%       in this toolbox:
%        .Connectivity  the connectivity that was used
%        .ImageSize     size(BW)
%        .NumObjects    the number of connected components
%        .PixelIdxList  1 x NumObjects cell array, each cell a column vector
%                       of the linear indices of the voxels in that component
%--------------------------------------------------------------------------
% EXAMPLES
% mask = zeros(10,10); mask(2,2) = 1; mask(5:8,5:8) = 1;
% CC = conncomp_bw( mask );
% CC.NumObjects
% cellfun(@numel, CC.PixelIdxList)
%--------------------------------------------------------------------------
% Copyright (C) - 2026 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------
Dim = size( BW );
D   = ndims( BW );
if D == 2 && any( Dim == 1 )
    D = 1;   % a row/column vector is 1D
end

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'connectivity', 'var' )
    if D == 3
        connectivity = 26;
    else
        connectivity = 8;
    end
end

%%  Main Function
%--------------------------------------------------------------------------
% Build the neighbour offsets for the requested connectivity
offsets = neighbour_offsets( D, connectivity );

BW = BW ~= 0;
labels = zeros( Dim );
fg = find( BW );

nextlabel = 0;
% Iterative flood fill (breadth first) using an explicit stack so that
% large 3D volumes do not blow the recursion limit.
stack = zeros( numel(fg), 1 );   % preallocated work stack of linear indices
for s = 1:numel( fg )
    seed = fg(s);
    if labels(seed) ~= 0
        continue
    end
    nextlabel = nextlabel + 1;
    labels(seed) = nextlabel;
    sp = 1;
    stack(sp) = seed;
    while sp > 0
        idx = stack(sp);
        sp  = sp - 1;
        nbrs = neighbours( idx, Dim, offsets );
        for n = nbrs(:)'
            if BW(n) && labels(n) == 0
                labels(n) = nextlabel;
                sp = sp + 1;
                stack(sp) = n;
            end
        end
    end
end

%%  Package the output like bwconncomp
%--------------------------------------------------------------------------
CC.Connectivity = connectivity;
CC.ImageSize    = Dim;
CC.NumObjects   = nextlabel;
CC.PixelIdxList = cell( 1, nextlabel );
for l = 1:nextlabel
    CC.PixelIdxList{l} = find( labels == l );
end

end

%==========================================================================
function offsets = neighbour_offsets( D, connectivity )
% Return the subscript offsets to the neighbours of a voxel for the given
% dimension and connectivity.

if D == 1
    offsets = [-1; 1];
    return
end

if D == 2
    [dx, dy] = ndgrid( -1:1, -1:1 );
    off = [dx(:), dy(:)];
    off( all(off == 0, 2), : ) = [];          % drop the centre
    if connectivity == 4
        off( sum(abs(off), 2) ~= 1, : ) = [];  % keep face neighbours only
    elseif connectivity ~= 8
        error('conncomp_bw:connectivity', 'In 2D connectivity must be 4 or 8.')
    end
    offsets = off;
elseif D == 3
    [dx, dy, dz] = ndgrid( -1:1, -1:1, -1:1 );
    off = [dx(:), dy(:), dz(:)];
    off( all(off == 0, 2), : ) = [];          % drop the centre
    dist = sum( abs(off), 2 );                 % 1 = face, 2 = edge, 3 = corner
    switch connectivity
        case 6
            off( dist > 1, : ) = [];
        case 18
            off( dist > 2, : ) = [];
        case 26
            % keep all 26
        otherwise
            error('conncomp_bw:connectivity', 'In 3D connectivity must be 6, 18 or 26.')
    end
    offsets = off;
else
    error('conncomp_bw:dimension', 'The dimension must be 1, 2 or 3.')
end

end

%==========================================================================
function nbrs = neighbours( idx, Dim, offsets )
% Given a linear index into an array of size Dim, return the linear indices
% of its in-bounds neighbours defined by the subscript offsets.

D = numel( Dim );
subs = cell( 1, D );
[subs{:}] = ind2sub( Dim, idx );
sub = [subs{:}];

cand = offsets + sub;                          % nOff x D candidate subscripts

% Drop candidates that fall outside the array bounds
inbounds = all( cand >= 1, 2 ) & all( cand <= Dim, 2 );
cand = cand(inbounds, :);

if isempty( cand )
    nbrs = [];
    return
end

csub = num2cell( cand, 1 );
nbrs = sub2ind( Dim, csub{:} );

end
