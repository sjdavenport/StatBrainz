%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the apower function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
x = -50:0.1:50;
y = apower(x);
fprintf('apower: %d inputs -> output range [%g, %g]\n', numel(x), min(y), max(y));
plot(x,y)
x = randn(1,10000);
histogram(apower(x));
