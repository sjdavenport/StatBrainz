%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srf_contour function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

srf = loadsrf('fs5', 'sphere')
data = randn(srf.lh.nvertices,1);
mask = smooth_surface(srf.lh, data, 20) > 0;
[inner_contour, outer_contour] = srf_contour(srf.lh, mask);
subplot(1,3,1)
srfplot(srf.lh, mask); title('Original Mask', 'color', 'white')
subplot(1,3,2)
srfplot(srf.lh, inner_contour); title('Inner Contour', 'color', 'white')
subplot(1,3,3)
srfplot(srf.lh, outer_contour); title('Outer Contour', 'color', 'white')
exportgraphics(gcf, [statbrainz_maindir, 'tests/Figures/srf_contour.png'])
