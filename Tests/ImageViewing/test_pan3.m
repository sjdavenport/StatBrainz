%% test_pan3
% Tests of the pan3 function (smoke tests, figures off).
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')
img = imgload('MNImask');

%% Runs with the default rotation
figure; pan3( img, [30, 40, 50] );

%% Runs with a given rotation
figure; pan3( double(img), [45, 50, 40], 2 );

%% Returns an output
figure; out = pan3( img, [30, 40, 50] );
assert(~isempty(out))
close all
