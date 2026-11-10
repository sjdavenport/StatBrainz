%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the tfce function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For a voxel with value t in a cluster that has size e at every height,
% tfce = dh * sum_{h = h0+dh, h0+2dh, ..., <= t} e^E h^H.
% With t = 1, dh = 0.1, H = 2, E = 0.5, h0 = 0:
%   tfce = 0.1 * sqrt(e) * (0.1^2 + 0.2^2 + ... + 1^2) = 0.385*sqrt(e).
rng(0)

%% Single voxel (default H, E, dh and h0)
im = zeros(5,5); im(3,3) = 1;
tf = tfce( im );
assert( isequal( size(tf), [5,5] ) )
assert( abs( tf(3,3) - 0.385 ) < 1e-10 )
assert( all( tf(im == 0) == 0 ) )

%% Two neighbouring voxels: the extent term is sqrt(2)
im = zeros(5,5); im(2,2) = 1; im(2,3) = 1;
tf = tfce( im, 2, 0.5, 8, 0.1 );
assert( abs( tf(2,2) - 0.385*sqrt(2) ) < 1e-10 )
assert( abs( tf(2,3) - tf(2,2) ) < 1e-12 )

%% Connectivity: diagonal voxels are one cluster for 8, two for 4
im = zeros(5,5); im(2,2) = 1; im(3,3) = 1;
tf8 = tfce( im, 2, 0.5, 8, 0.1 );
tf4 = tfce( im, 2, 0.5, 4, 0.1 );
assert( abs( tf8(2,2) - 0.385*sqrt(2) ) < 1e-10 )
assert( abs( tf4(2,2) - 0.385 ) < 1e-10 )

%% H, E and h0
im = zeros(4,4); im(1,1) = 1; im(1,2) = 1;
tf = tfce( im, 1, 1, 8, 0.1 );         % 0.1*2*(0.1+...+1) = 1.1
assert( abs( tf(1,1) - 1.1 ) < 1e-10 )
im = zeros(4,4); im(2,2) = 1;
tf = tfce( im, 2, 0.5, 8, 0.1, 0.5 );  % 0.1*(0.6^2+...+1^2) = 0.33
assert( abs( tf(2,2) - 0.33 ) < 1e-10 )

%% Different heights in one cluster
% Values 1 and 2 next to each other: below 1 the cluster has 2 voxels,
% above 1 only the voxel with value 2 remains.
im = zeros(4,4); im(2,2) = 1; im(2,3) = 2;
tf = tfce( im, 2, 0.5, 8, 0.5 );
% heights 0.5, 1 have extent 2; heights 1.5, 2 have extent 1
assert( abs( tf(2,2) - 0.5*sqrt(2)*(0.25 + 1) ) < 1e-10 )
assert( abs( tf(2,3) - 0.5*(sqrt(2)*(0.25 + 1) + 2.25 + 4) ) < 1e-10 )

%% Zero image and negative values
assert( isequal( tfce( zeros(6,6) ), zeros(6,6) ) )
assert( isequal( tfce( -ones(4,4) ), zeros(4,4) ) )

%% 3D: default connectivity is 26
im = zeros(4,4,4); im(1,1,1) = 1; im(2,2,2) = 1;   % corner neighbours
tf = tfce( im );
assert( isequal( size(tf), [4,4,4] ) )
assert( abs( tf(1,1,1) - 0.385*sqrt(2) ) < 1e-10 )
tf6 = tfce( im, 2, 0.5, 6 );
assert( abs( tf6(1,1,1) - 0.385 ) < 1e-10 )
