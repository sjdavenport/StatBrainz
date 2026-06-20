%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the fdp_calc function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
rejection_loc_mask = rand(25, 25) > 0.7;
signal_loc_mask = rand(25, 25) > 0.5;
fdp = fdp_calc( rejection_loc_mask, signal_loc_mask )
