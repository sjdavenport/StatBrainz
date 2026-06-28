%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the peak2circle function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ circlemask ] = peak2circle( [49,50,49] );
fprintf('peak2circle: mask size [%s], %d voxels set\n', ...
    num2str(size(circlemask)), nnz(circlemask));
imagesc(circlemask(:,:,98))
