%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the numOfConComps function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0)

%% 2D: default connectivity is 4
data = zeros(6,6);
data(1,1) = 2; data(2,2) = 2;    % diagonal neighbours
data(4:5, 4:6) = 3;              % a block of 6
data(6,1) = 0.5;                 % below the threshold
[n, occ, sizes, idx] = numOfConComps( data, 1 );
assert( n == 3 )
assert( isequal( sizes, [1,6] ) )
assert( isequal( occ, [2,1] ) )
assert( numel(idx) == 3 )
assert( isequal( sort(cell2mat(idx(:))), find(data > 1) ) )

%% 2D connectivity 8
[n, occ, sizes] = numOfConComps( data, 1, 8 );
assert( n == 2 )
assert( isequal( sizes, [2,6] ) && isequal( occ, [1,1] ) )

%% The threshold is strict (data > thresh)
assert( numOfConComps( data, 3 ) == 0 )
assert( numOfConComps( data, 2.9 ) == 1 )

%% No suprathreshold voxels
[n, occ, sizes, idx] = numOfConComps( zeros(4,4), 1 );
assert( n == 0 && isempty(occ) && isempty(sizes) && isempty(idx) )

%% 3D: default connectivity is 18
data = zeros(4,4,4);
data(1,1,1) = 2; data(2,1,1) = 2;   % face neighbours
data(3,2,1) = 2;                    % edge neighbour of (2,1,1)
data(4,3,2) = 2;                    % corner neighbour of (3,2,1)
assert( numOfConComps( data, 1 ) == 2 )
assert( numOfConComps( data, 1, 6 ) == 3 )
assert( numOfConComps( data, 1, 26 ) == 1 )

%% Errors for an invalid connectivity or dimension
try
    numOfConComps( randn(5,5), 0, 6 );
    errored = 0;
catch
    errored = 1;
end
assert( errored == 1 )

try
    numOfConComps( randn(4,4,4), 0, 8 );
    errored = 0;
catch
    errored = 1;
end
assert( errored == 1 )

try
    numOfConComps( randn(3,3,3,3), 0 );
    errored = 0;
catch
    errored = 1;
end
assert( errored == 1 )

%% All clusters the same size
% Two clusters of size 3: expect occurences = 2 and cluster_sizes = 3
data = zeros(5,5);
data(1,1:3) = 2;
data(4,1:3) = 2;
[n, occ, sizes] = numOfConComps( data, 1 );
assert( n == 2 )
assert( isequal( sizes, 3 ) && isequal( occ, 2 ), ...
    'numOfConComps gives the wrong sizes when all clusters have the same size' )
