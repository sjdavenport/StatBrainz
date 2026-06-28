%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the custom_colormap function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
cmap = custom_colormap([1, 1, 0], [0.5, 0, 0.5], 64);
fprintf('custom_colormap: returned colormap of size [%s]\n', num2str(size(cmap)));
colormap(cmap)
imagesc(rand(10))
colorbar
exportgraphics(gcf, [statbrainz_maindir, 'tests/Figures/custom_colormap.png'])
