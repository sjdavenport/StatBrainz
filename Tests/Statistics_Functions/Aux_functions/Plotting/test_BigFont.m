%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the BigFont function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
figure; plot(1:10, rand(1,10)); title('Test BigFont');
BigFont(24)
figpath = [statbrainz_maindir, 'tests/Figures/BigFont.png'];
exportgraphics(gcf, figpath)
fprintf('BigFont: figure written, file exists: %d\n', isfile(figpath));
