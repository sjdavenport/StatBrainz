%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the conncomp_bw function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The flood fill (use_flood_fill = 1) is tested directly so that the
% results do not depend on the Image Processing Toolbox. The comparison
% with bwconncomp is in Tests/Aux_Functions/test_ipt_free_functions.m.
rng(0)

%% Output fields and default 2D connectivity (8)
BW = zeros(6,6);
BW(2,2) = 1; BW(3,3) = 1;   % diagonal neighbours
BW(5:6,5:6) = 1;            % a 2x2 block
CC = conncomp_bw( BW, 8, 1 );
assert( isequal( CC.Connectivity, 8 ) )
assert( isequal( CC.ImageSize, [6,6] ) )
assert( CC.NumObjects == 2 )
assert( isequal( size(CC.PixelIdxList), [1,2] ) )
assert( isequal( CC.PixelIdxList{1}, sub2ind([6,6], [2;3], [2;3]) ) )
assert( isequal( CC.PixelIdxList{2}, sub2ind([6,6], [5;6;5;6], [5;5;6;6]) ) )
CCdef = conncomp_bw( BW );
assert( CCdef.NumObjects == 2 )
assert( CCdef.Connectivity == 8 )

%% 2D connectivity 4 separates diagonal neighbours
CC = conncomp_bw( BW, 4, 1 );
assert( CC.NumObjects == 3 )
assert( isequal( sort(cellfun(@numel, CC.PixelIdxList)), [1,1,4] ) )

%% PixelIdxList entries are column vectors that cover the foreground once
BW = rand(15,12) > 0.5;
CC = conncomp_bw( BW, 4, 1 );
assert( all( cellfun(@iscolumn, CC.PixelIdxList) ) )
allidx = sort( cell2mat( CC.PixelIdxList(:) ) );
assert( isequal( allidx, find(BW) ) )

%% Non-zero values (not only 1) are foreground
CC = conncomp_bw( [0, 2, -3, 0, 0.5], 8, 1 );
assert( CC.NumObjects == 2 )
assert( isequal( CC.PixelIdxList{1}, [2;3] ) )
assert( isequal( CC.PixelIdxList{2}, 5 ) )

%% 1D column vector
CC = conncomp_bw( [1;1;0;1;0;1;1;1], 8, 1 );
assert( CC.NumObjects == 3 )
assert( isequal( cellfun(@numel, CC.PixelIdxList), [2,1,3] ) )

%% 3D connectivity 6, 18 and 26 and default 26
BW = zeros(4,4,4);
BW(1,1,1) = 1; BW(2,1,1) = 1;   % face neighbours
BW(3,2,1) = 1;                  % edge neighbour of (2,1,1)
BW(4,3,2) = 1;                  % corner neighbour of (3,2,1)
CC6  = conncomp_bw( BW, 6, 1 );
CC18 = conncomp_bw( BW, 18, 1 );
CC26 = conncomp_bw( BW, 26, 1 );
assert( CC6.NumObjects == 3 )
assert( CC18.NumObjects == 2 )
assert( CC26.NumObjects == 1 )
assert( isequal( CC26.ImageSize, [4,4,4] ) )
CCdef = conncomp_bw( BW );
assert( CCdef.NumObjects == 1 && CCdef.Connectivity == 26 )

%% Empty foreground
CC = conncomp_bw( zeros(5,5), 8, 1 );
assert( CC.NumObjects == 0 )
assert( isempty( CC.PixelIdxList ) )

%% Errors for an invalid connectivity or dimension
try
    conncomp_bw( ones(3,3), 6, 1 );
    errored = 0;
catch err
    errored = strcmp( err.identifier, 'conncomp_bw:connectivity' );
end
assert( errored == 1 )

try
    conncomp_bw( ones(3,3,3), 8, 1 );
    errored = 0;
catch err
    errored = strcmp( err.identifier, 'conncomp_bw:connectivity' );
end
assert( errored == 1 )

try
    conncomp_bw( ones(2,2,2,2), 8, 1 );
    errored = 0;
catch
    errored = 1;
end
assert( errored == 1 )
