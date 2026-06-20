%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the Gkerderiv function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
val = GkerMV(1, 3)
deriv = Gkerderiv(1, 3)
h = 0.00001;
valplushx = GkerMV(1+h, 3);
(valplushx - val)/h

% Compare to GkerMVderiv (GkerMVderiv is not present in this package)
% GkerMVderiv(0.5, 3)
Gkerderiv(0.5, 3)
