function [ data_pw ] = prewhiten( data )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% data = Xgen2( 10000, 176, 0.7, 'ar1' );
% data_pw = prewhiten( data );
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
data_pw = zeros(size(data));
for I = 1:size(data, 1)
    I
    ts = data(I,:);
    ts_cov = cov(ts);
    ts_cov_sqrt = sqrt(ts_cov);
    
    data_pw = inv(ts_cov_sqrt)*ts;
end

end

