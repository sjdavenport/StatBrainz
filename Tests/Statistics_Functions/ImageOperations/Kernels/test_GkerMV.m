%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the GkerMV function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NB: GkerMV returns only the kernel value (single output); the multi-output
% derivative calls in the original example were written for a
% derivative-returning version, so they are reduced to val here. See GkerMV2 /
% Gker for derivative outputs.

%%
val = GkerMV([1.5,2], 3)

%%
val = GkerMV([1,2]', 3)
h = 0.00001;
valplushx = GkerMV([1+h,2]', 3);
valplushx
valplushy = GkerMV([1,2+h]', 3);
(valplushx - val)/h
(valplushy - val)/h

%%
val = GkerMV([1,2]', 3)
val = GkerMV([1,3;2,4], 3)

%%
% Recover sigma2
x = [0,0]';
D = length(x);
1/GkerMV(x,4,0)^(2/D)/(2*pi)
% Recover FWHM
FWHM = 3;
sigma2 = 1/GkerMV(x,FWHM)^(2/D)/(2*pi);
sigma2FWHM(sigma2^(1/2))
