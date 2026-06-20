%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the localized_vi function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
tstat_orig = randn(25, 25);
region_masks = { tstat_orig > 0, tstat_orig < 0 };
vec_of_maxima = max(randn(1000, 25*25), [], 2);
[pvals, max_tstat_within_region] = localized_vi( tstat_orig, region_masks, vec_of_maxima )
