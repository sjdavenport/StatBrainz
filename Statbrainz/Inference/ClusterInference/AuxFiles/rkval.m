function rk = rkval(k, d)
% RKVAL computes the r_k constant used in the clusterTP lower bound
% calculation, defined as min_{1<=i<=k} (fdk(i,d) - i) / fdk(i,d).
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  k   the cluster-size threshold (positive integer)
% Optional
%  d   the dimension of the lattice (default: 3)
%--------------------------------------------------------------------------
% OUTPUT
% rk   the r_k constant (a scalar in [0,1])
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------
if nargin < 2
    d = 3;  % Default value for d
end

min_value = Inf;  % Initialize minimum value
for i = 1:k
    fdki = fdk(i, d);
    min_value = min(min_value, (fdki - i) / fdki);
end

rk = min_value;
end

function result = fdk(k, d)
if d == 0 || k == 0
    result = 0;
else
    floork1overd = floor(k^(1/d));
    ldk = floor((log(k) - d*log(floork1overd)) / (log(floork1overd+1) - log(floork1overd)));
    bdkplus = (floork1overd + 1)^(d-ldk) * (floork1overd + 2)^ldk;
    bdk = floork1overd^(d-ldk) * (floork1overd + 1)^ldk;
    result = bdkplus + fdk(k-bdk, d-1);
end
end