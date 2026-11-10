%% test_viewdata2
% Tests of the viewdata2 function (figures off).
%--------------------------------------------------------------------------
rng(1)
set(0, 'DefaultFigureVisible', 'off')
mask1 = rand(20, 20) > 0.5;
mask2 = rand(20, 20) > 0.7;

%% Default alphas
figure; viewdata2( {mask1, mask2}, {[1,0,0], [0,0,1]} );

%% One region and given alphas
figure; viewdata2( {mask1}, {[0,1,0]}, 0.5 );

%% Each region uses its own alpha
% Only checked when the graphics system returns the image objects.
figure; viewdata2( {mask1, mask2}, {[1,0,0], [0,0,1]}, [1, 0.25] );
kids = get(gca, 'Children');
if numel(kids) == 3
    % Children are listed with the last image drawn first
    assert(isequal(get(kids(1), 'AlphaData'), 0.25*mask2))
    assert(isequal(get(kids(2), 'AlphaData'), 1*mask1))
end
close all
