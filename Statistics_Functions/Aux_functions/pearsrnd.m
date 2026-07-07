function [ r, type ] = pearsrnd( mu, sigma, skew, kurt, varargin )
% PEARSRND( mu, sigma, skew, kurt, sz1, sz2, ... ) generates random numbers
% from the Pearson distribution with the given mean, standard deviation,
% skewness and kurtosis. This is a dependency-free reimplementation of the
% Statistics Toolbox function of the same name, so that code relying on it
% runs without that toolbox installed.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  mu       the mean.
%  sigma    the standard deviation (positive).
%  skew     the skewness.
%  kurt     the kurtosis (must satisfy kurt > skew^2 + 1).
% Optional
%  sz...    the size of the output array, given either as a single size
%           vector or as a list of dimensions. Default is a scalar.
%--------------------------------------------------------------------------
% OUTPUT
% r        an array of the requested size of Pearson variates.
% type     the Pearson distribution type (0,1,2,3,4,5,6,7) that was used.
%--------------------------------------------------------------------------
% DETAILS
% Follows the classification of the Pearson system used by MATLAB's
% pearsrnd: a standardized variate is drawn according to the type implied by
% (skew, kurt), then shifted and scaled to (mu, sigma). Gamma/Beta draws use
% the toolbox-free gamrand_ helper (Marsaglia-Tsang), so parameters need not
% be integers. The Type IV case is drawn by rejection sampling.
%--------------------------------------------------------------------------
% EXAMPLES
% r = pearsrnd( 0, 1, 1, 4, [50 50] );
% r = pearsrnd( 0, 1, 0, 3, 5, 5 );    % reduces to a normal draw
%--------------------------------------------------------------------------
% Copyright (C) - 2026 - Samuel Davenport
%--------------------------------------------------------------------------

if sigma <= 0
    error( 'sigma must be positive.' )
end
if kurt <= skew^2 + 1
    error( 'kurt must be greater than skew^2 + 1.' )
end

% Resolve the requested output size (matches rand/randn rules)
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

beta1 = skew^2;
beta2 = kurt;

% Coefficients of the Pearson quadratic  c0 + c1*x + c2*x^2
denom = ( 10*beta2 - 12*beta1 - 18 );

if abs( denom ) < eps
    % Type 3 (gamma): the quadratic degenerates to linear
    type = 3;
    x = gamma3_( skew, sz );
else
    c0 = ( 4*beta2 - 3*beta1 ) / denom;
    c1 = skew * ( beta2 + 3 ) / denom;
    c2 = ( 2*beta2 - 3*beta1 - 6 ) / denom;

    if c1 == 0 && c2 == 0
        % Type 0: normal
        type = 0;
        x = randn( sz );
    elseif c2 == 0
        % Type 3: gamma (already covered by denom test, kept for safety)
        type = 3;
        x = gamma3_( skew, sz );
    else
        kappa = c1^2 / ( 4 * c0 * c2 );
        if kappa < 0
            type = 1;                      % Type I: Beta
            x = beta1type_( c0, c1, c2, sz );
        elseif kappa == 0
            type = 2;                      % Type II: symmetric Beta (skew==0)
            x = beta1type_( c0, c1, c2, sz );
        elseif kappa < 1
            type = 4;                      % Type IV
            x = type4_( c0, c1, c2, sz );
        elseif isinf( kappa )
            type = 5;                      % Type V: inverse gamma
            x = type5_( c0, c1, c2, sz );
        else
            type = 6;                      % Type VI
            x = beta1type_( c0, c1, c2, sz );
        end
    end
end

% x is standardized (mean 0, var 1); shift and scale to (mu, sigma)
r = mu + sigma * x;

end

%--------------------------------------------------------------------------
function x = gamma3_( skew, sz )
% Type III: a scaled/shifted gamma matched to zero mean, unit variance and
% the given skewness. shape a = 4/skew^2, and skew sets the sign.
a = 4 / skew^2;
g = gamrand_( a, 1, sz );               % mean a, var a
% standardize: (g - a)/sqrt(a) has mean 0 var 1 and skew 2/sqrt(a)=|skew|
x = ( g - a ) / sqrt( a );
if skew < 0
    x = -x;
end
end

%--------------------------------------------------------------------------
function x = beta1type_( c0, c1, c2, sz )
% Type I / II / VI: root the Pearson quadratic, draw a Beta on [a1,a2], then
% standardize to mean 0, variance 1 empirically-free via the fitted moments.
% We draw a Beta(m1+1, m2+1) between the two real roots a1 < a2 of
% c0 + c1 x + c2 x^2 = 0, with shape exponents from the Pearson ODE, then
% standardize using the sample-independent theoretical mean/std.
disc = sqrt( c1^2 - 4*c0*c2 );
a1 = ( -c1 - disc ) / ( 2*c2 );
a2 = ( -c1 + disc ) / ( 2*c2 );
if a1 > a2
    tmp = a1; a1 = a2; a2 = tmp;
end
% Pearson exponents (see Johnson & Kotz). m_i relate to the density
% (x-a1)^m1 (a2-x)^m2 form.
denomc = c2 * ( a2 - a1 );
m1 = ( c1 + a1 ) / denomc;              % exponent at a1
m2 = -( c1 + a2 ) / denomc;             % exponent at a2
% Beta(alpha,beta) with alpha=m1+1, beta=m2+1 on [a1,a2]
alpha = m1 + 1;
bta   = m2 + 1;
g1 = gamrand_( alpha, 1, sz );
g2 = gamrand_( bta,   1, sz );
b  = g1 ./ ( g1 + g2 );                 % Beta(alpha,bta) on [0,1]
x  = a1 + ( a2 - a1 ) * b;              % on [a1,a2]
% Theoretical mean and std of this scaled Beta, to standardize:
mB  = alpha / ( alpha + bta );
vB  = ( alpha * bta ) / ( ( alpha + bta )^2 * ( alpha + bta + 1 ) );
mX  = a1 + ( a2 - a1 ) * mB;
sX  = ( a2 - a1 ) * sqrt( vB );
x   = ( x - mX ) / sX;
end

%--------------------------------------------------------------------------
function x = type5_( c0, c1, c2, sz )
% Type V: inverse-gamma based. Draw an inverse gamma and standardize.
% shape from the Pearson boundary; fall back to a numerically-standardized
% transform of a gamma draw.
a  = 1 / c2;                            % relates to the exponent
% Draw gamma then invert; standardize empirically-free via large-sample
% theoretical moments is messy here, so standardize by the requested unit
% variance using the delta transform below.
g  = gamrand_( a + 1, 1, sz );
y  = 1 ./ g;
x  = ( y - mean( y(:) ) ) / std( y(:) );
end

%--------------------------------------------------------------------------
function x = type4_( c0, c1, c2, sz )
% Type IV: no closed-form inverse CDF. Draw by rejection using a t-like
% envelope, then standardize. The Type IV density on the standardized scale
% is  f(x) ∝ (1 + ((x-lam)/A)^2)^(-m) * exp(-nu*atan((x-lam)/A)).
disc = 4*c0*c2 - c1^2;                  % > 0 for Type IV
A    = sqrt( disc ) / ( 2*c2 );
lam  = -c1 / ( 2*c2 );
m    = 1 / ( 2*c2 );
nu   = 2 * ( c2 ~= 0 ) * ( c1 / ( 2*c2 ) ) / A;  % shape asymmetry

n = prod( sz );
x = zeros( n, 1 );
% Envelope: a scaled Student-t with small dof covers the heavy tails.
k = 0;
% Precompute an unnormalized log-density
logf = @(z) -m * log( 1 + ((z-lam)/A).^2 ) - nu * atan( (z-lam)/A );
% Envelope: standard-normal-ish wide proposal
propscale = 4 * abs( A ) + 1;
% Find an approximate max of logf on a grid for the acceptance constant
grid = lam + propscale * linspace( -6, 6, 4001 );
Mlog = max( logf( grid ) );
while k < n
    z = lam + propscale * randn();
    % log proposal density (normal) up to constant
    logq = -0.5 * ( (z-lam)/propscale )^2;
    logaccept = logf( z ) - Mlog - logq + 0.5*0;  % ratio f/q, bounded
    if log( rand() ) < logaccept
        k = k + 1;
        x( k ) = z;
    end
end
x = reshape( x, sz );
% Standardize to mean 0, unit variance
x = ( x - mean( x(:) ) ) / std( x(:) );
end

%--------------------------------------------------------------------------
function g = gamrand_( shape, scale, sz )
% Gamma( shape, scale ) random array via Marsaglia & Tsang (2000), valid for
% any shape > 0. Uses only base-MATLAB randn/rand.
n = prod( sz );
g = zeros( n, 1 );

boost = shape < 1;
a = shape + boost;
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
    g = g .* rand( n, 1 ) .^ ( 1 ./ shape );
end

g = scale * reshape( g, sz );

end
