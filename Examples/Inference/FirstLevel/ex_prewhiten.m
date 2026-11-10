%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the prewhiten function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% AR(1) data along each row: data(:,t) = 0.7*data(:,t-1) + noise
data = filter( 1, [1, -0.7], randn(10000, 176), [], 2 );
data_pw = prewhiten( data );
