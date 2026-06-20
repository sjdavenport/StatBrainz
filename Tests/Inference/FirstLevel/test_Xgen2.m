%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the Xgen2 function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = Xgen2( 1000, 1000, 0.7, 'ar1' );
mean(std(X,0,1))

%%
% NB: Xgen2 takes only 4 arguments (n, m, rho, method); the 5th-argument
% form below is from the docstring but is not supported, so it is commented out.
% X = Xgen2( 1000, 1000, 0.7, 'ar1', '012');
% mean(std(X,0,1))

%%
% NB: the 'armix' method is not implemented in Xgen2 (does not assign X), so
% this example is commented out.
% X = Xgen2( 1000, 1000, [0.7,0.7], 'armix' );
% mean(std(X,0,1))

%%
X = Xgen2( 1000, 1000, 0.7, 'equi' );
mean(std(X,0,1))

%%
% NB: the 'Gaussian' method depends on fconv (from the RFTtoolbox, not present
% in this package), so this example is commented out.
% X = Xgen2( 1000, 1000, 0.7, 'Gaussian' );
% mean(std(X,0,1))
