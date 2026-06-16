function [ interval, std_error ] = bernstd( p, N, level )
% BERNSTD( p, N, level ) generates the Bernoulli standard error confidence
% intervals that arise from the central limit theorem.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  p       a numeric vector of proportions (values in [0,1]).
%  N       the sample size.
% Optional
%  level   the confidence level. Default is 0.95.
%--------------------------------------------------------------------------
% OUTPUT
%  interval    a 2-by-length(p) matrix; row 1 is the lower bound and
%              row 2 the upper bound of the confidence interval.
%  std_error   a 1-by-length(p) vector of standard errors.

%--------------------------------------------------------------------------
% EXAMPLES
% bernstd(0.05,1000,0.95)
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'level', 'var' )
   % default option of alpha
   level = 0.95;
end

std_error = zeros(1,length(p));
interval = zeros(2,length(p));

%%  Main Function Loop
%--------------------------------------------------------------------------
for I = 1:length(p)
    std_error(I) = (p(I)*(1-p(I)))^(1/2)*norminv( 1-(1-level)/2 )/sqrt(N);
    interval(:,I) = [ p(I) - std_error(I), p(I) + std_error(I) ];
end
end

