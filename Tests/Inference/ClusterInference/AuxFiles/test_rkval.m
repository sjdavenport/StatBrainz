%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the rkval function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
k = 10;
rk = rkval(k);
fprintf('rkval(%d) = %g\n', k, rk);

k = 10;
d = 2;
rk = rkval(k, d);
fprintf('rkval(%d, %d) = %g\n', k, d, rk);
