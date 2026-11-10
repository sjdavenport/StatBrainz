function [ y ] = apower( x, power )
% APOWER( x, power ) raises x to a given power, preserving sign for
% negative values (i.e. computes sign(x)*|x|^power).
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  x       a numeric array
% Optional
%  power   the exponent to apply. Default is 1/2.
%--------------------------------------------------------------------------
% OUTPUT
%  y       numeric array the same size as x, with each element equal to
%          sign(x(i))*|x(i)|^power
%--------------------------------------------------------------------------
% Copyright (C) - 2025 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'power', 'var' )
   % Default value
   power = 1/2;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
xposlocs = x >= 0;
xneglocs = x < 0;

y = zeros(size(x));
y(xposlocs) = x(xposlocs).^power;
y(xneglocs) = -(-x(xneglocs)).^power;

end

