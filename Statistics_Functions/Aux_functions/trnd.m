function r = trnd( nu, varargin )
% TRND( nu, sz1, sz2, ... ) generates random numbers from a Student's t
% distribution with nu degrees of freedom. This is a dependency-free
% reimplementation of the Statistics Toolbox function of the same name, so
% that code relying on it runs without that toolbox installed.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  nu       the degrees of freedom (a positive scalar). May be non-integer.
% Optional
%  sz...    the size of the output array, given either as a single size
%           vector ( trnd(nu, [m n]) ) or as a list of dimensions
%           ( trnd(nu, m, n) ). Default is a scalar.
%--------------------------------------------------------------------------
% OUTPUT
% r        an array of the requested size of t(nu) random variates.
%--------------------------------------------------------------------------
% DETAILS
% A t(nu) variate is constructed as Z / sqrt( V / nu ) where Z ~ N(0,1) and
% V ~ chi^2(nu) = Gamma( nu/2, 2 ), with Z and V independent. The Gamma
% draw uses the Marsaglia-Tsang method, so nu need not be an integer.
%--------------------------------------------------------------------------
% EXAMPLES
% r = trnd( 5 );
% r = trnd( 3, [50 50] );
% r = trnd( 10, 5, 5 );
%--------------------------------------------------------------------------
% Copyright (C) - 2026 - Samuel Davenport
%--------------------------------------------------------------------------

if ~isscalar( nu ) || ~isnumeric( nu ) || nu <= 0
    error( 'nu (the degrees of freedom) must be a positive scalar.' )
end

% Resolve the requested output size from varargin (matches rand/randn rules)
if isempty( varargin )
    sz = [1 1];
elseif numel( varargin ) == 1
    s = varargin{1};
    if isscalar( s )
        sz = [s s];
    else
        sz = s(:)';
    end
else
    sz = cell2mat( varargin );
end

% Z ~ N(0,1)
z = randn( sz );

% V ~ chi^2(nu) = Gamma( shape = nu/2, scale = 2 ), drawn without toolboxes
v = gamrand_( nu/2, 2, sz );

r = z ./ sqrt( v / nu );

end

%--------------------------------------------------------------------------
function g = gamrand_( shape, scale, sz )
% Gamma( shape, scale ) random array via Marsaglia & Tsang (2000), valid for
% any shape > 0. Uses only base-MATLAB randn/rand.
n = prod( sz );
g = zeros( n, 1 );

% Marsaglia-Tsang is derived for shape >= 1. For shape < 1, draw at shape+1
% and rescale by U^(1/shape) (Stuart's theorem).
boost = shape < 1;
a = shape + boost;               % effective shape used in the sampler
d = a - 1/3;
c = 1 ./ sqrt( 9 * d );

k = 0;
while k < n
    x = randn();
    v = ( 1 + c * x )^3;
    if v <= 0
        continue
    end
    u = rand();
    if log( u ) < 0.5 * x^2 + d - d * v + d * log( v )
        k = k + 1;
        g( k ) = d * v;
    end
end

if boost
    % Rescale the shape+1 draws down to the requested shape < 1
    g = g .* rand( n, 1 ) .^ ( 1 ./ shape );
end

g = scale * reshape( g, sz );

end
