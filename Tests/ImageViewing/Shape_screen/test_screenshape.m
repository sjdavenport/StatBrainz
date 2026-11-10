%% test_screenshape
% Tests of the screenshape function (figures off).
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')
shape = [10, 20, 300, 400];

%% Sets the figure position
figure; imagesc(rand(5));
screenshape( shape );
assert(isequal(get(gcf, 'Position'), shape))

%% A second input sets the background to white
% Only checked when the graphics system returns the colour.
figure; imagesc(rand(5));
screenshape( shape, 1 );
assert(isequal(get(gcf, 'Position'), shape))
col = get(gcf, 'Color');
if numel(col) == 3
    assert(isequal(col, [1, 1, 1]))
end

%% Returns the screen size
figure; screen_size = screenshape( shape );
assert(isequal(screen_size, get(0, 'ScreenSize')))
close all
