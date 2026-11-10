%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    Tests for the voxLCE function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The voxel threshold u solves (u^(H+1) - h0^(H+1))/(H+1) = tfce_threshold.
rng(0)

%% Known threshold: tfce_threshold = 9, H = 2, h0 = 0 gives u = 3
tstat = [2.9, 3.1; 3.0, 10];
sig = voxLCE( tstat, 9, 2, 0 );
assert( islogical(sig) )
assert( isequal( sig, [false, true; false, true] ) )

%% Default H = 2 and h0 = 0
assert( isequal( voxLCE( tstat, 9 ), sig ) )

%% h0: (27 + 1)^(1/3) = 3.0366
tstat = [3.03, 3.04];
assert( isequal( voxLCE( tstat, 9, 2, 1 ), [false, true] ) )
assert( isequal( voxLCE( tstat, 9, 2, 0 ), [true, true] ) )

%% H = 1: u = sqrt(2*8) = 4
assert( isequal( voxLCE( [3.99, 4.01], 8, 1 ), [false, true] ) )

%% Output has the size of the input (3D)
tstat = randn(4,5,6)*3;
sig = voxLCE( tstat, 5 );
assert( isequal( size(sig), [4,5,6] ) )
assert( isequal( sig, tstat > 15^(1/3) ) )

%% A voxel above the voxLCE threshold has TFCE above the TFCE threshold
im = zeros(5,5); im(3,3) = 4;
tf = tfce( im, 2, 0.5, 8, 0.01 );
assert( voxLCE( im(3,3), 15 ) == 1 && tf(3,3) > 15 )
