%% test_MySmooth
% Tests for MySmooth: Gaussian smoothing followed by scaling to a maximum of 1.
%--------------------------------------------------------------------------
tol = 1e-10;

%% FWHM = 0 only rescales the image
Img = [0 2; 4 1];
assert( isequal( MySmooth( Img, 0 ), Img/4 ) )

%% FWHM = 0 with a logical image returns a double copy
Img = logical([0 1; 1 0]);
sImg = MySmooth( Img, 0 );
assert( isa( sImg, 'double' ) && isequal( sImg, double(Img) ) )

%% 2D impulse gives a normalised Gaussian bump
Img = zeros(31); Img(16,16) = 1; FWHM = 4;
sImg = MySmooth( Img, FWHM );
sigma = FWHM/sqrt(8*log(2));
[i, j] = ndgrid( -5:5, -5:5 );
expected = exp( -(i.^2 + j.^2)/(2*sigma^2) );
assert( max( abs( sImg(11:21, 11:21) - expected ), [], 'all' ) < tol )
assert( abs( max(sImg(:)) - 1 ) < tol )

%% A scalar FWHM is used in every direction
Img = double( MkRadImg( [30, 30], [15.5, 15.5] ) <= 5 );
assert( max( abs( MySmooth( Img, 4 ) - MySmooth( Img, [4 4] ) ), [], 'all' ) < tol )

%% Result matches fast_conv divided by its maximum
s = fast_conv( Img, [3 6], 2 );
assert( max( abs( MySmooth( Img, [3 6] ) - s/max(s(:)) ), [], 'all' ) < tol )

%% 3D input keeps its size and has a maximum of 1
Img = double( MkRadImg( [15, 16, 17], [8, 8, 9] ) <= 3 );
sImg = MySmooth( Img, 3 );
assert( isequal( size(sImg), [15, 16, 17] ) )
assert( abs( max(sImg(:)) - 1 ) < tol )
