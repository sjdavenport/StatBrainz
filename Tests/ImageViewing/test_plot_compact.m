%% test_plot_compact
% Tests of the plot_compact function (smoke tests, figures off).
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')

%% Runs and tiles can be drawn in
figure; plot_compact( 2, 3 );
for I = 1:6
    nexttile; imagesc(rand(5));
end

%% A single tile
figure; plot_compact( 1, 1 );
nexttile; plot(1:10);
close all
