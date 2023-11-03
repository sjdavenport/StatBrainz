function rk = rk(k, d)
% Example: rk(81,3)
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