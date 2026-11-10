%% test_MkRadImg
% Tests for MkRadImg: Euclidean distance of each voxel to a centre point.
%--------------------------------------------------------------------------
tol = 1e-12;

%% 3D values computed by hand
R = MkRadImg( [2,2,2], [0,0,0] );
assert( isequal( size(R), [2 2 2] ) )
assert( abs( R(1,1,1) - sqrt(3) ) < tol )
assert( abs( R(2,1,1) - sqrt(6) ) < tol )
assert( abs( R(2,2,2) - sqrt(12) ) < tol )

%% 2D values computed by hand
R = MkRadImg( [3,4], [1,1] );
assert( isequal( size(R), [3 4] ) )
assert( R(1,1) == 0 )
assert( abs( R(3,4) - sqrt(13) ) < tol )
assert( abs( R(2,1) - 1 ) < tol )

%% Matches an independent loop computation
c = [2.5, 4, 1.5]; R = MkRadImg( [4,5,3], c );
for i = 1:4, for j = 1:5, for k = 1:3
    assert( abs( R(i,j,k) - norm( [i j k] - c ) ) < tol )
end, end, end

%% 1D or 4D Dim gives an error
for Dim = { 5, [2 2 2 2] }
    err = 0;
    try
        MkRadImg( Dim{1}, ones(1, length(Dim{1})) );
    catch
        err = 1;
    end
    assert( err == 1 )
end
