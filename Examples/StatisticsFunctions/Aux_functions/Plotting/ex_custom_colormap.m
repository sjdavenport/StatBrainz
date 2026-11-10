%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the custom_colormap function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
cmap = custom_colormap([1, 1, 0], [0.5, 0, 0.5], 64);
fprintf('custom_colormap: returned colormap of size [%s]\n', num2str(size(cmap)));
colormap(cmap)
imagesc(rand(10))
colorbar
exportgraphics(gcf, [statbrainz_maindir, 'Examples/Figures/custom_colormap.png'])
