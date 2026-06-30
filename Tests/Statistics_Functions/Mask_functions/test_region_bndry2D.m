%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the region_bndry2D function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mask = imgload('MNImask');

% Build two synthetic regions as sub-volumes of the brain mask
region1 = false(size(mask));
region1(30:45, 40:55, 70:90) = mask(30:45, 40:55, 70:90) > 0;
region2 = false(size(mask));
region2(50:65, 40:55, 70:90) = mask(50:65, 40:55, 70:90) > 0;
regions = {region1, region2};

masksum2D = region_bndry2D(regions, mask);
sum(masksum2D(:))
