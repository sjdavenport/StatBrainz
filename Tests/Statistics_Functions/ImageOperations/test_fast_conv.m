%% test_fast_conv
% Tests for fast_conv: separable Gaussian smoothing in 1, 2 and 3 D.
%--------------------------------------------------------------------------
tol = 1e-12;

%% FWHM = 0 returns the data and ss = 1
data = [1 2 3; 4 5 6];
[s, ss] = fast_conv( data, 0 );
assert( isequal( s, data ) && ss == 1 )

%% 1D impulse (row) gives the truncated kernel, default truncation ceil(4*sigma)
FWHM = 4; data = zeros(1, 41); data(21) = 1;
[s, ss] = fast_conv( data, FWHM );
trunc = ceil( 4*FWHM2sigma(FWHM) );
expected = zeros(1, 41);
expected( 21 + (-trunc:trunc) ) = Gker( -trunc:trunc, FWHM );
assert( isequal( size(s), [1 41] ) )
assert( max( abs( s - expected ) ) < tol )
assert( abs( ss - sum( Gker( -trunc:trunc, FWHM ).^2 ) ) < tol )

%% ss is close to the continuous value 1/(2*sqrt(pi)*sigma)
[~, ss] = fast_conv( zeros(1, 50), 3, 1, 30 );
assert( abs( ss - 1/( 2*sqrt(pi)*FWHM2sigma(3) ) ) < 1e-6 )

%% Truncation argument limits the kernel support
s = fast_conv( data, FWHM, 1, 2 );
assert( all( s( abs( (1:41) - 21 ) > 2 ) == 0 ) )
assert( abs( s(23) - Gker(2, FWHM) ) < tol )

%% 2D anisotropic impulse gives the outer product of the 1D kernels
data = zeros(31); data(16,16) = 1; FWHM = [2 5];
s = fast_conv( data, FWHM );
% default truncation is ceil(4*sigma) = [4 9]
k1 = Gker( -4:4, FWHM(1) ); k2 = Gker( -9:9, FWHM(2) );
assert( max( abs( s(12:20, 7:25) - k1'*k2 ), [], 'all' ) < tol )
assert( all( s([11 21], :) == 0, 'all' ) )

%% 3D impulse gives the product of the 1D kernels
data = zeros(15,15,15); data(8,8,8) = 1; FWHM = 3;
s = fast_conv( data, FWHM );
k = Gker( -3:3, FWHM );
[a, b, c] = ndgrid( k, k, k );
assert( max( abs( s(5:11, 5:11, 5:11) - a.*b.*c ), [], 'all' ) < tol )

%% Smoothing a constant keeps it constant away from the border
s = fast_conv( 5*ones(40, 40), 3 );
assert( abs( s(20,20) - 5*sum( Gker( -6:6, 3 ) )^2 ) < tol )
assert( abs( s(20,20) - 5 ) < 1e-3 )

%% Several 1D subjects are smoothed one by one
rng(0); data = randn(20, 3);
s = fast_conv( data, 3, 1 );
for J = 1:3
    assert( max( abs( s(:,J) - fast_conv( data(:,J), 3, 1 ) ) ) < tol )
end

%% Several 2D subjects are smoothed one by one
data = randn(12, 13, 2);
s = fast_conv( data, 2, 2 );
assert( isequal( size(s), [12 13 2] ) )
assert( max( abs( s(:,:,2) - fast_conv( data(:,:,2), 2 ) ), [], 'all' ) < tol )

%% D > 3 gives an error
err = 0;
try
    fast_conv( randn(3,3,3,3), 2, 4 );
catch
    err = 1;
end
assert( err == 1 )

%% 1D column input gives a column with the same values as a row input
data_row = zeros(1, 41); data_row(21) = 1; s_row = fast_conv( data_row, 4 ); FWHM = 4;
s_col = fast_conv( data_row', FWHM );
assert( isequal( size(s_col), [41 1] ) && max( abs( s_col - s_row' ) ) < tol )
