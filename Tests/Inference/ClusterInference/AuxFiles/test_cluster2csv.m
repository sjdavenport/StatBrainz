%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the cluster2csv function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)
savedir = [tempname, '/'];
mkdir(savedir);

%% 3D cluster: header and values
cluster = [1, 2, 3; 4, 5, 6; 7, 8, 9];
cluster2csv( cluster, 'c3', savedir );
assert( exist( [savedir, 'c3.csv'], 'file' ) == 2 )
lines = strsplit( strtrim( fileread([savedir, 'c3.csv']) ), '\n' );
lines = strtrim(lines);
assert( strcmp( lines{1}, 'x,y,z' ) )
assert( numel(lines) == 4 )
assert( isequal( str2double( strsplit(lines{3}, ',') ), [4,5,6] ) )

%% 2D and 1D clusters
cluster2csv( [1, 2; 3, 4], 'c2', savedir );
lines = strtrim( strsplit( strtrim( fileread([savedir, 'c2.csv']) ), '\n' ) );
assert( strcmp( lines{1}, 'x,y' ) && numel(lines) == 3 )
cluster2csv( [5; 6; 7], 'c1', savedir );
lines = strtrim( strsplit( strtrim( fileread([savedir, 'c1.csv']) ), '\n' ) );
assert( strcmp( lines{1}, 'x' ) && numel(lines) == 4 )
assert( str2double(lines{4}) == 7 )

%% Error for more than 3 columns
try
    cluster2csv( ones(2,4), 'c4', savedir );
    errored = 0;
catch
    errored = 1;
end
assert( errored == 1 )

rmdir( savedir, 's' );
